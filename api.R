library(httr)
library(dplyr)
library(tidyr)
library(jsonlite)

base.url = 'https://api.sleeper.app/v1/league/801713921697349632/'

# IDs
pull.ids = GET('https://api.sleeper.app/v1/players/nfl')
ids = fromJSON(rawToChar(pull.ids$content))
ids.trim = ids[lengths(ids) == 46]

base.ids = as.data.frame(do.call(rbind, ids.trim)) %>% tibble::rownames_to_column(., "sleeper_id")


# Franchises
pull.us = GET(paste0(base.url, 'users'))
users = fromJSON(rawToChar(pull.us$content))


# Rosters
pull.rosters = GET(paste0(base.url, "rosters"))

rosters = as.data.frame(fromJSON(rawToChar(pull.rosters$content))) %>%
  select(owner_id, roster_id, players)

rosters.split = rosters %>% unnest(players) %>% 
  inner_join(users, by = c('owner_id' = 'user_id')) %>% 
  inner_join(ids.table, by = c('players' = 'sleeper_id'))
