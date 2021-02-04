library(jsonlite)
library(tidyverse)
library(tibble)
library(magrittr)

# 대차대조표
url_bs = 'https://api.stock.naver.com/stock/MSFT.O/finance/balance/annual'
data_bs = fromJSON(url_bs, flatten = TRUE)
str(data_bs)
data_bs = as_tibble(data_bs$rowList)

data_bs = data_bs %>% select('title', contains('value')) %>%
  column_to_rownames('title')

data_bs = data_bs %>%
  sapply(., function(x) {
    str_replace_all(x, ',', '') %>%
      as.numeric()
  }) %>%
  data.frame(., row.names = rownames(data_bs)) %>%
  set_colnames(colnames(data_bs) %>% str_remove_all('\\.') %>% parse_number())
  

# 클렌징 부분 함수로
data_clean = function(url) {
  data = fromJSON(url, flatten = TRUE)
  data = as_tibble(data$rowList)
  
  data = data %>% select('title', contains('value')) %>%
    column_to_rownames('title')
  
  data = data %>%
    sapply(., function(x) {
      str_replace_all(x, ',', '') %>%
        as.numeric()
    }) %>%
    data.frame(., row.names = rownames(data)) %>%
    set_colnames(colnames(data) %>% str_remove_all('\\.') %>% parse_number())
    
}

# 3대 재무제표 다운로드
data_bs_a = data_clean('https://api.stock.naver.com/stock/AAPL.O/finance/balance/annual')
data_income_a = data_clean('https://api.stock.naver.com/stock/AAPL.O/finance/income/annual')
data_cash_a = data_clean('https://api.stock.naver.com/stock/AAPL.O/finance/cash/annual')
data_bind_a = bind_rows(data_bs_a, data_income_a, data_cash_a) %>% select(sort(names(.)))

# 기업 설명
url_overview = 'https://api.stock.naver.com/stock/AAPL.O/overview'
data_overview = fromJSON(url_overview)
data_overview = data.frame(num = data_overview$stockItemListedInfo$countOfListedStock,
                           mv = data_overview$stockItemListedInfo$marketValueFull %>% parse_number(),
                           ex = data_overview$stockItemListedInfo$stockExchange,
                           summary = data_overview$summary)

# 한번에 함수로
data_clean = function(url) {
  data = fromJSON(url, flatten = TRUE)
  data = as_tibble(data$rowList)
  
  data = data %>% select('title', contains('value')) %>%
    column_to_rownames('title')
  
  data = data %>%
    sapply(., function(x) {
      str_replace_all(x, ',', '') %>%
        as.numeric()
    }) %>%
    data.frame(., row.names = rownames(data)) %>%
    set_colnames(colnames(data) %>% str_remove_all('\\.') %>% parse_number()) %>%
    select(sort(names(.)))
}

data_down = function(ticker) {
  
  # 기업정보
  url_overview = paste0('https://api.stock.naver.com/stock/', ticker, '/overview')
  data_overview = fromJSON(url_overview)
  data_overview = data.frame(num = data_overview$stockItemListedInfo$countOfListedStock,
                             mv = data_overview$stockItemListedInfo$marketValueFull %>% parse_number(),
                             ex = data_overview$stockItemListedInfo$stockExchange,
                             summary = data_overview$summary)
  write.csv(data_overview, paste0(ticker, '_overview.csv'))
  
  # 재무재표 (연간)
  data_bs_a = data_clean(paste0('https://api.stock.naver.com/stock/',ticker,'/finance/balance/annual'))
  data_income_a = data_clean(paste0('https://api.stock.naver.com/stock/',ticker,'/finance/income/annual'))
  data_cash_a = data_clean(paste0('https://api.stock.naver.com/stock/',ticker,'/finance/cash/annual'))
  data_bind_a = bind_rows(data_bs_a, data_income_a, data_cash_a) %>% select(sort(names(.)))
  write.csv(data_bind_a, paste0(ticker, '_annual.csv'))
  
  # 재무제표 (분기)
  data_bs_q = data_clean(paste0('https://api.stock.naver.com/stock/',ticker,'/finance/balance/quarter'))
  data_income_q = data_clean(paste0('https://api.stock.naver.com/stock/',ticker,'/finance/income/quarter'))
  data_cash_q = data_clean(paste0('https://api.stock.naver.com/stock/',ticker,'/finance/cash/quarter'))
  data_bind_q = bind_rows(data_bs_q, data_income_q, data_cash_q) %>% select(sort(names(.)))
  write.csv(data_bind_q, paste0(ticker, '_quarter.csv'))
  
  Sys.sleep(1)
  
}

data_down('AAPL.O')
data_down('MSFT.O')
