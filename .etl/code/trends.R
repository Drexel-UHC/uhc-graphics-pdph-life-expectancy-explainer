#' This file will prep data for Followup 1: trends
 

{# US Trends ---------------------------------------------------------------

  df_us = read.csv("raw/NCHS_-_Death_rates_and_life_expectancy_at_birth.csv") %>% as_tibble() %>% 
    janitor::clean_names() %>% 
    filter(race == "All Races", sex == 'Both Sexes',
           year > 1980) %>% 
    select(year, 
           le = average_life_expectancy_years) %>% 
    mutate(group = 'US')
  
  json_us = df_us %>% jsonlite::write_json("clean/le_us.json")  
  
}


{ # Philly Simulated --------------------------------------------------------
  
  df_philly =  read.csv("clean/le_gpt_philly.csv.txt") %>% as_tibble() %>% 
    mutate(group = "Philadelphia")
  
  df_data = bind_rows(df_philly, df_us)
  df_data %>% 
    ggplot(aes(x =year, y = le, group = group, color = group))+
    geom_line()+
    ylim(60,80)
  
  ## Export
  df_data %>% jsonlite::write_json("clean/le_us_philly.json")
}

