# Sys.setenv(TZ = 'UTC')

library(magrittr)
library(dplyr)
library(tidyr)
library(PerformanceAnalytics)
library(lubridate)
library(timetk)
library(ggplot2)

# sh = excel_sheets('raw.xlsx')
# 
# raw = lapply(sh, function(x) {
#   read_excel('raw.xlsx', sheet = x)
# })
# 
# openxlsx::read.xlsx('raw.xlsx', sheet  = 'price')

raw = readRDS('raw.Rds')

# 가격 0으로 바꾼 뒤 수익률 계산

raw[['ret']] = raw[['price']] %>% 
  replace(is.na(.), 0) %>%
  mutate_at(vars(-c(Date)), function(x) x/lag(x)-1) %>%
  mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x)) %>%
  tk_xts() 


ep = raw[['price']]['Date'] %>% filter(Date >= '1995-12-31') %>% pull() %>% as.character()
wts = replicate(5, list())
wt_zero = rep(0, ncol(raw[['ret']]))

for (k in 1 : length(ep)) {
  
  i = ep[k]
  
  # i = '1996-01-31'
  
  data_fs = raw[['fs']] %>% filter(계정명 %in% c('매출액(천원)', '총자산(평균)(천원)', '수정BPS(원)')) %>%
    filter(
      if ( month(i) <= 4 ) {
        일자  == year(i) - 2
      } else {
        일자  == year(i) - 1
      }
    ) %>% select('계정명', contains('A')) %>%
    gather(key, value, -c('계정명')) %>%
    spread('계정명', 'value') %>%
    mutate_at(vars(-c('key')), as.numeric) %>%
    mutate(GPA = `매출액(천원)` / `총자산(평균)(천원)`) %>%
    select(key, GPA, `수정BPS(원)`)
  
  data_stop = raw[['stop']] %>% filter(Date == i) %>%
    gather(key, value, -c('Date')) %>%
    rename('거래' = 'value')
  
  data_cap = raw[['cap']] %>% filter(Date == i) %>%
    gather(key, value, -c('Date')) %>%
    rename('시총' = 'value')
  
  data_join = raw[['price']] %>% filter(Date == i) %>%
    gather(key, value, -c('Date')) %>%
    rename('주가' = 'value') %>%
    left_join(data_fs, by = 'key') %>%
    left_join(data_stop, by = c('Date', 'key')) %>%
    left_join(data_cap, by = c('Date', 'key'))
  
  data_join  = data_join %>% mutate(시총_perc = percent_rank(시총)) %>%
    mutate(PBR = 주가 / `수정BPS(원)`) %>%
    mutate(id = row_number(),
           rank_GPA = dense_rank(desc(GPA)),
           rank_PBR = dense_rank(PBR),
           rank_SUM = rank_GPA + rank_PBR
           ) %>%
    mutate(rank_SUM = ifelse(거래 != '정상', NA,
                                ifelse(`수정BPS(원)` <= 0, NA, 
                                      ifelse(시총_perc <= 0.05, NA, rank_SUM)))) %>%
    mutate(rank_tile = ntile(rank_SUM, 5))
  
  for (x in 1:5) {
    wt = wt_zero
    idx = data_join %>% filter(rank_tile == x) %>% select(id) %>% pull()
    wt[idx] = 1/length(idx)
    
    ## mean(raw[['ret']][ep[k+1], idx])
    
    wts[[x]][[i]] = xts(t(wt), order.by = as.Date(i))
  }
  
  print(i)
   
}

wts = lapply(wts, function(x) {
  do.call(rbind, x)
})

result = lapply(wts, function(x) {
  Return.portfolio(raw[['ret']], x)
})   

port_bind = do.call(cbind, result) %>% set_names(paste0("port_", rep(1:5))) 
charts.PerformanceSummary(port_bind)

port_bind %>% fortify.zoo() %>% 
  mutate_at(vars(-c(Index)), function(x) cumsum(log(1+x))) %>%
  gather(key, value, -c('Index')) %>%
  ggplot(aes(x = Index, y = value, group = key)) +
  geom_line(aes(color = key)) +
  theme_bw() +
  theme(legend.position="bottom", legend.title=element_blank()) +
  xlab('') +
  ylab('') +
  scale_x_date(date_labels = "%Y", breaks = '2 year')
  

                     