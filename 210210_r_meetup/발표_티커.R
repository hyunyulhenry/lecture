#NYSE 예제
library(jsonlite)
library(dplyr)

url = paste0('https://api.stock.naver.com/stock/exchange/NYSE/marketValue?page=1&pageSize=60')
data = fromJSON(url, flatten = TRUE)

data = as_tibble(data$stocks)
head(data, 3)

data = data %>% 
  select(reutersCode, symbolCode, stockName, stockNameEng, closePrice, accumulatedTradingValue, accumulatedTradingValue,
         marketValue, dividend, `stockExchangeType.name`, `industryCodeType.industryGroupKor`) %>%
  mutate(closePrice = parse_number(closePrice),
         accumulatedTradingValue = parse_number(accumulatedTradingValue),
         marketValue = parse_number(marketValue),
         dividend = parse_number(dividend))

# 함수로 묶기
down_data = function(ex) {
  
  data_list = list()
  
  tryCatch({
    
    for (i in 1 : 100) {
      
      url = paste0('https://api.stock.naver.com/stock/exchange/',ex,'/marketValue?page=',i,'&pageSize=60')
      data = fromJSON(url, flatten = TRUE)
      
      data = as_tibble(data$stocks)
      
      data = data %>% 
        select(reutersCode, symbolCode, stockName, stockNameEng, closePrice, accumulatedTradingValue, accumulatedTradingValue,
               marketValue, dividend, `stockExchangeType.name`, `industryCodeType.industryGroupKor`) %>%
        mutate(closePrice = parse_number(closePrice),
               accumulatedTradingValue = parse_number(accumulatedTradingValue),
               marketValue = parse_number(marketValue),
               dividend = parse_number(dividend))
      
      
      if (length(data) > 1) {
        data_list[[i]] = data
      } else {
        break
      }
      
      print(i)
      Sys.sleep(1)
    }
    
  }, error = function(e) {} )
  
  data_bind = bind_rows(data_list)
  
}

ticker_nyse = down_data('NYSE')
ticker_nasdaq = down_data('NASDAQ')
ticker_amex = down_data('AMEX')

ticker = rbind(ticker_nyse, ticker_nasdaq, ticker_amex)

# 종가 0 인것: 대부분 펀드
ticker %>% filter(closePrice == 0)

# ADR 들어간 종목
ticker %>% filter(str_detect(stockNameEng, 'ADR'))

# Fund
ticker %>% filter(str_detect(stockNameEng, 'Fund'))

# Acquision: 스팩, 인수합병 등
ticker %>% filter(str_detect(stockNameEng, 'Acquisition'))

# PRF: 우선주
ticker %>% filter(str_detect(stockNameEng, 'PRF'))
ticker %>% filter(str_detect(stockName, 'Pref'))

# 비슷한 것
ticker %>% group_by(stockName) %>% summarize(n()) %>% arrange(desc(`n()`))
ticker %>% group_by(stockNameEng) %>% summarize(n()) %>% arrange(desc(`n()`))

ticker %>% filter(str_detect(stockNameEng, 'II'))
ticker %>% filter(str_detect(stockNameEng, 'III'))
ticker %>% filter(str_detect(stockNameEng, 'IV'))
ticker %>% filter(str_detect(stockNameEng, 'V')) 
ticker %>% filter(str_detect(stockNameEng, '\\.'))
ticker %>% filter(str_detect(stockNameEng, 'Class A'))
ticker %>% filter(str_detect(stockNameEng, 'Class B'))
ticker %>% filter(str_detect(stockNameEng, 'Class C'))
ticker %>% filter(str_detect(stockNameEng, 'Class D'))
ticker %>% filter(str_detect(stockNameEng, 'Class E'))
ticker %>% filter(str_detect(stockNameEng, 'Unit')) 
ticker %>% filter(str_detect(stockNameEng, 'Series A'))
ticker %>% filter(str_detect(stockNameEng, 'Series B'))
ticker %>% filter(str_detect(stockNameEng, 'Series C'))
ticker %>% filter(str_detect(stockNameEng, 'Series D'))
ticker %>% filter(str_detect(stockNameEng, 'Series E'))
  
# 중복종목 제거
spe_char = c('II', 'III', 'IV', 'V', '\\.', 'Class A', 'Class B', 'Class C', 'Class D', 'Class E',
             'Unit', 'Series A', 'Series B', 'Series C', 'Series D', 'Series E') %>%
  str_c(., collapse="|")

ticker_mod = ticker %>% filter(closePrice != 0) %>%
  filter(!str_detect(stockNameEng, 'ADR')) %>%
  filter(!str_detect(stockNameEng, 'Fund')) %>%
  filter(!str_detect(stockNameEng, 'Acquisition'))  %>%
  filter(!str_detect(stockName, 'Pref')) %>%
  filter(!str_detect(stockNameEng, 'PRF')) %>%
  distinct(stockName, .keep_all = TRUE) %>%
  distinct(stockNameEng, .keep_all = TRUE) %>%
  mutate(clean_name = str_remove_all(stockNameEng, spe_char)) %>%
  distinct(clean_name, .keep_all = TRUE)