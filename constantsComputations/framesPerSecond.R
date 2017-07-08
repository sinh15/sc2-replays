################################
## FRAMES PER SECOND COMPUTATION
################################

# The ggracker API game simple details returns the Game Length in complete seconds.
# Nonetheless, the advanced details gives key information (e.g. units) for a specific game frame.
# This means that we need to know the real 'Replay Frames per Second' in order to convert
# specific frame events into a match specific second.

# Game duration will always be only completed seconds. So a game that lasts:
### 300.0 real seconds => 300 seconds through api
### 300.2 real seconds => 300 secons through api
### 300.6 real seconds => 300 seconds through api

# This means, that given enough games, and using 'X' as the game length returned by the API,
# the games lengths would always be compressed by the interval [X, X+1) and that the average
# game length should almost be X.5

# To get which was the last frame of the game, we will need to 

# We need a big enough current game sample, to compute the average Frames per Second. For that
# we will pull the last 500 ladder 1v1 games.

require(jsonlite)

fps <- data.frame()
numPages <- 50

for(i in 1:numPages) {
    apiURI <- paste0('http://api.ggtracker.com/api/v1/matches?category=Ladder&game_type=1v1&page=', i)
    gamesJSON <- fromJSON(apiURI)
    games <- gamesJSON[['collection']]
    gameIDS <- games[['id']]
    durations <- games[['duration_seconds']]
   
    for(j in 1:length(gameIDS)) {
        Sys.sleep(0.5)
        advURI <- paste0('https://gg2-matchblobs-prod.s3.amazonaws.com/', gameIDS[j])
        advJSON <- fromJSON(advURI)
        p1 <- advJSON[['armies_by_frame']][[1]]
        p2 <- advJSON[['armies_by_frame']][[2]]
        
        unitsLastFrame <- c(p1[, 3], p2[, 3])
        lastFrame <- as.integer(row.names(sort(table(unitsLastFrame), decreasing=TRUE))[1])
        
        gameData <- as.data.frame(matrix(c(gameIDS[j], durations[j], lastFrame), ncol=3))
        fps <<- rbind(fps, gameData)
        
        current <- (i-1)*10+j
        max <- numPages*length(gameIDS)
        message(paste0('Completed ', current, ' of ', max, ' : ', round(current/max*100, digits=0), '%'), appendLF=TRUE)
        flush.console()
    }
}

fps2 <- fps
fps2$V2 <- fps2$V2+0.5
fps2$fps <- fps2$V3/fps2$V2
View(sort(table(fps2$fps), decreasing=TRUE))
summary(fps2) ## 22.4


