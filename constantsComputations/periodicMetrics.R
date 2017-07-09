#############################
## PERIODIC METRICS REPORTING
#############################

# The ggtracker API returns a series of variables like: resources lost, workers active, mineralsCurrent, ... in a periodic manner.
# The number of intervals depends on the game length, but it is not clear which is the real duration of each interval.

# It seems that the real interval duration is 7.XX, but in order to compute which is the most probable outcome, we are going to use
# a 500 ladder game 1v1 sample. For each game, asuming that the game makes a snapshoot of the metrics systematically after 7.xx seconds,
# we are going to compute which is the theoretical Minimum & Maximum interval values for each game, creating a range of possible '7.xx' (X) values.

### The maximum will be defined by: (spaces-1)X = duration+X => X = duration/(spaces-2)
### The minimum will be defined by: (spaces-1)X = duration-X => X = duration/spaces

# Hopefully, given enough games, the sample will normalize, and half of the games will have ended in the middle of the following range:
# [Interval Computed, Next Interval]

# Asuming also that the games does not do an extra 'screenshot of the metrics' when the game ends, if we deduct 3.5 seconds to each game duration,
# we would get, in average, the real last interval screenshoot timer. In those cases, the maximum & minimum X durations should be the same,
# because we would have fallen in an exact interval. Therefore, the meadians of both metrics should be almost equal.

# Another way of reading the interval of minimum & maximum values is that given enough games, and without modifying the game duration,
# the real interval duration should usually move between: Minimum 3rd quantile - Maximum 1st quantile.


# Load jsonlite library
require(jsonlite)

# @fps -> will contain each game data: ID, Duration (seconds), Last Frame
periodic <- data.frame()

# iterate to 50 pages (10 games per page = 500 games)
numPages <- 50
for(i in 1:numPages) {
  # get basic details of last 10 games paginated by variable 'i' and extract ids & durations
  apiURI <- paste0('http://api.ggtracker.com/api/v1/matches?category=Ladder&game_type=1v1&page=', i)
  gamesJSON <- fromJSON(apiURI)
  games <- gamesJSON[['collection']]
  gameIDS <- games[['id']]
  durations <- games[['duration_seconds']]
  
  # iterate through each game of the page
  for(j in 1:length(gameIDS)) {
    # delay call + extract details to not crash the API
    Sys.sleep(0.5)
    advURI <- paste0('https://gg2-matchblobs-prod.s3.amazonaws.com/', gameIDS[j])
    advJSON <- fromJSON(advURI)
    spaces <- length(advJSON[['Lost']][[1]])

    # storde data in overall data frame FPS
    gameData <- as.data.frame(matrix(c(gameIDS[j], durations[j], spaces), ncol=3))
    periodic <<- rbind(periodic, gameData)
    
    # paste progress in console
    current <- (i-1)*10+j
    max <- numPages*length(gameIDS)
    message(paste0('Completed ', current, ' of ', max, ' : ', round(current/max*100, digits=0), '%'), appendLF=TRUE)
    flush.console()
  }
}

# backup to save data
names(periodic) <- c('id', 'duration', 'spaces')
write.csv(periodic, file='periodicMetrics.csv')

# manipulation
# Two scenarios (normal duartion & modified duration)
### Max: (spaces-1)X = duration + X -> X = duration/(spaces-2)
### Min: (spaces-1)X = duration - X -> X = duration/spaces
periodic$durationModified <- periodic$duration-3.5
periodic$min <- periodic$duration/periodic$spaces
periodic$max <- periodic$duration/(periodic$spaces-2)
periodic$minM <- periodic$durationModified/periodic$spaces
periodic$maxM <- periodic$durationModified/(periodic$spaces-2)

# summary
summary(periodic)
periodic2 <- periodic[periodic$max < quantile(periodic$max, 0.95), ]
summary(periodic2)

# Probably real itnerval value lies within: 7.046 - 7.053 (for each game compute what it makes sense)
# Although it seems same to asume the value: 7.05 (every 20 intervals, roughly 2:20 minutes, one extra second)
# This means that given an avg game duration of 728 seconds, we would avoid a 5 seconds 'noise gap in the end'.