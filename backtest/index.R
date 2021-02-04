setwd("D:/R/lecture/backtest")

library(readxl)
library(magrittr)
library(dplyr)
library(tidyr)
library(tibble)
library(timetk)
library(PerformanceAnalytics)

# 엑셀의 시트 확인하기
readxl::excel_sheets('raw.xlsx')

# 가격 데이터 
raw = list()
raw[['price']] = read_excel('raw.xlsx', sheet = 'price')

ncol(raw[['price']])

head(raw[['price']], 15)

# 시계열 데이터 정리 함수
clean_ts = function(df) {
  df %>% set_colnames(.[8, ]) %>%
    slice(-1:-13) %>%
    mutate_all(as.numeric) %>%
    rename('Date' = 'Symbol') %>%
    mutate(Date = as.Date(Date, origin = '1899-12-30')) %>%
    tk_xts()
}

# 가격 정리하기
raw[['price']] = clean_ts(raw[['price']])

head(raw[['price']][1:10, 1:10])

# 거래량
raw[['volume']] = read_excel('raw.xlsx', sheet = 'volume') %>%
  set_colnames(.[8, ]) %>%
  slice(-1:-13) %>%
  mutate_all(as.numeric) %>%
  rename('Date' = 'Symbol') %>%
  mutate(Date = as.Date(Date, origin = '1899-12-30')) %>%
  tk_xts()

# 시가총액
raw[['cap']] = read_excel('raw.xlsx', sheet = 'cap') %>%
  set_colnames(.[8, ]) %>%
  slice(-1:-13) %>%
  mutate_all(as.numeric) %>%
  rename('Date' = 'Symbol') %>%
  mutate(Date = as.Date(Date, origin = '1899-12-30')) %>%
  tk_xts()

# 순이익
raw[['ni']] = read_excel('raw.xlsx', sheet = 'ni')

head(raw[['ni']])

# 재무제표 데이터 정리 함수
clean_fs = function(df) {
  df %>%
  .[, -(c(1,2,4,5))] %>%
  set_colnames(.[4, ]) %>%
  slice(-1:-5) %>%
  {colnames(.)[1] = "Index"; .} %>%
  data.frame() %>%
  column_to_rownames('Index')
}
  
raw[['ni']] = raw[['ni']] %>% clean_fs()

head(raw[['ni']][1:10, 1:10])

# 나머지 재무제표도 불러옴
raw[['equity']] = read_excel('raw.xlsx', sheet = 'equity') %>% clean_fs()
raw[['bps']] = read_excel('raw.xlsx', sheet = 'bps') %>% clean_fs()

# 열이름 확인
lapply(raw, colnames) %>% Reduce(all.equal.character, .) 
  

test= list()
test[[1]] = 'a'
test[[2]] = 'a'
test[[3]] = 'a'

test %>% Reduce(all.equal.character, .)

sapply(raw, colnames) %>% data.frame()  %>% all_equal()

length(unique(as.list(z))) == 1      
                           