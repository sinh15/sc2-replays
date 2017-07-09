# Read details from a game
require(jsonlite)
details <- fromJSON('http://api.ggtracker.com/api/v1/matches/7109386.json')

names(details) 
# [1] "id"               "ended_at"         "winning_team"     "category"         "game_type"        "average_league"   "duration_seconds" "release_string"  
# [9] "replays_count"    "summaries_count"  "expansion"        "cobrand"          "map_name"         "map"              "map_url"          "entities"        
# [17] "replays"

id <- details[['id']] # integer (7109386)

ended <- as.Date(x <- substr(details[['ended_at']], 1, 10), format='%Y-%m-%d') # date (2017-07-09)

winner <- details[['winning_team']] # integer (2)

category <- details[['category']] # character (Ladder)

gameType <- details[['game_type']] # character (1v1)

averageLeague <- details[['average_league']] # integer (4)

duration <- details[['duration_seconds']] # integer (667)

release <- details[['release_string']] # character (3.15.1.54724)

replaysCount <- details[['replays_count']] # integer (1)

summaries <- details[['summaries_count']] # integer (0)

expansion <- details[['expansion']] # integer (2, legacy)

cobrand <- details[['cobrand']] # null

mapName <- details[['map_name']] # character (Proxima Station LE)

map <- details[['map']] # List of 5
map[['id']] # integer (8947)
map[['name']] # character (Proxima Station LE)
map[['gateway']] # character (us)
map[['s2ma_hash']] # character (347150ad07b3078cb7de934cf7fdea40219e7eb3719ad0be30eba1982f4944b4)
map[['image_Scale']] # null

mapURL <- details[['map_url']] # null

replays <- details[['replays']] # data frame: 3 variables (id, md5, url)
replays$id # integer (4513362)
replays$md5 # character (f1c9e503283c330ef9785f12ff28fb8e)
replays$url # character (https://gg2-replays-prod.s3.amazonaws.com/f1c9e503283c330ef9785f12ff28fb8e.SC2Replay)


