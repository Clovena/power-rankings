
library(dplyr)
library(nflreadr)


df = load_player_stats(stat_type = 'offense') %>%
  rename(Player = player_display_name, Position = position_group, Week = week)

gp = df %>% group_by(Player, Position, Week) %>% summarise(
  
  attempts = sum(attempts),
  completions = sum(completions),
  passing_yards = sum(passing_yards), 
  passing_tds = sum(passing_tds),
  interceptions = sum(interceptions),
  sacks = sum(sacks),
  
  carries = sum(carries),
  rushing_yards = sum(rushing_yards),
  rushing_tds = sum(rushing_tds),
  
  targets = sum(targets),
  receptions = sum(receptions),
  receiving_yards = sum(receiving_yards),
  receiving_tds = sum(receiving_tds),
  
  fumbles = sum(sack_fumbles, rushing_fumbles, receiving_fumbles),
  fum_lost = sum(sack_fumbles_lost, rushing_fumbles_lost, receiving_fumbles_lost),
  
  two_pt = sum(passing_2pt_conversions, rushing_2pt_conversions, receiving_2pt_conversions)
  
) %>% ungroup() %>% group_by(Player, Position, Week) %>% mutate(
  
  scrim_yards = rushing_yards + receiving_yards,
  scrim_tds = rushing_tds + receiving_tds,
  yardage_bonus = ifelse(passing_yards >= 300 | rushing_yards >= 100 | receiving_yards >= 100, 3, 0),
  te_premium = ifelse(Position == "TE", receptions / 2, 0),
  
  points = sum(
    passing_yards * 0.04,
    passing_tds * 4,
    interceptions * (-1), 
    sacks * (-2),
    
    scrim_yards * 0.1,
    scrim_tds * 6,
    receptions * 1,
    
    fumbles * (-0.5),
    fum_lost * (-1.5),
    
    two_pt * 2,
    yardage_bonus * 1,
    te_premium * 1
  )
  
)

sum = gp %>% group_by(Player, Position) %>%
  summarise(games = n(), fpts = sum(points), stdev = round(sd(points, na.rm = T), 3)) %>% ungroup() %>% 
  arrange(Position, desc(fpts))



test = sum %>% select(any_of(c("Player", "Pos")))
