# game duration = 744
# https://gg2-matchblobs-prod.s3.amazonaws.com/7108703

require(jsonlite)
adJSON <- fromJSON('https://gg2-matchblobs-prod.s3.amazonaws.com/7108703')

# LISTS
##############################

# resources lost
length(adJSON[['Lost']][[1]]) # 105
length(adJSON[['Lost']][[2]]) # 105

# workers active count
length(adJSON[['WorkersActiveCount']][[1]]) # 105
length(adJSON[['WorkersActiveCount']][[1]]) # 105

# minerals current
length(adJSON[['MineralsCurrent']][[1]]) # 105
length(adJSON[['MineralsCurrent']][[1]]) # 105

# minerals collection rate
length(adJSON[['MineralsCollectionRate']][[1]]) # 105
length(adJSON[['MineralsCollectionRate']][[1]]) # 105

# vespene current
length(adJSON[['VespeneCurrent']][[1]]) # 105
length(adJSON[['VespeneCurrent']][[1]]) # 105

# vespene collection rate
length(adJSON[['VespeneCollectionRate']][[1]]) # 105
length(adJSON[['VespeneCollectionRate']][[1]]) # 105

# supply usage
length(adJSON[['SupplyUsage']][[1]]) # 210 (105*2)
length(adJSON[['SupplyUsage']][[1]]) # 210 (105*2)


# First frame of periodic metrics corresponds to second = 0. Therefore, in this game, there are
# 104 other measurements over the timespan of 744 seconds.

104*x = 744 + x
103*x = 744
x = 744/103 # 7.223301
x= 744/105 # 7.085714