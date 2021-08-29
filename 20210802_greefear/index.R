# crawling
library(rvest)
library(httr)
library(readr)
library(gridExtra)

url = 'https://money.cnn.com/data/fear-and-greed/'
data = GET(url)
data_index = data %>% read_html() %>% html_nodes(xpath = '//*[@id="needleChart"]/ul/li[1]') %>%
  html_text() 

