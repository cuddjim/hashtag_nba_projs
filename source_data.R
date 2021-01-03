
library(tidyverse); library(magrittr);
library(httr); library(stringi); library(reshape2); library(tools)
library(formattable); library(DT); library(xml2); library(rvest)

url <- 'https://hashtagbasketball.com/fantasy-basketball-projections'

pgsession <- html_session(url)
pgform <-html_form(pgsession)

cats <- paste0("ctl00$ContentPlaceHolder1$CB",toupper(c('fgp','fgm','ftm','ftp','3pm','pts','reb','ast','stl','blk','to')))

for (i in cats){pgform[[1]][[5]][[i]]$value <- "checked"}

filled_form <-set_values(pgform[[1]], "ctl00$ContentPlaceHolder1$DDSHOW" = "400")

d <- submit_form(session=pgsession, form=filled_form)

projs <- d %>%
    html_nodes("table") %>%
    .[[3]] %>%
    html_table(header=TRUE) %>% 
    rename_all(~gsub('3pm','threes',gsub('\\%','pct',tolower(.)))) %>% 
    mutate_at(vars(matches('pct$')),~stringr::str_sub(.,1,4)) %>% 
    mutate(player = stringr::word(player,1, 2, sep = ' ')) %>% 
    mutate(pos = stringr::word(pos,1,1,sep = ',')) %>% 
    mutate(pos2 = gsub('P','',pos)) %>% 
    drop_na(player) %>% 
    mutate_at(vars(-c(player,matches('pos'),team)),~as.numeric(.)) %>% 
    select(player, matches('pos'),everything(),-`r#`)

projs_total <- projs %>% 
    mutate_at(vars(threes,pts,treb,ast,stl,blk,to),~round(.*gp,0)) %>% select(-total)
