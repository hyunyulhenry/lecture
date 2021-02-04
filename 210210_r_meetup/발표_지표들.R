# Shiller CAPE (US)
library(rvest)
library(httr)
library(dplyr)
library(lubridate)
library(stringr)
library(magrittr)
library(highcharter)
library(timetk)

Sys.setlocale("LC_ALL", "English")

url = 'https://www.multpl.com/shiller-pe/table/by-month'
data = GET(url)

data_table = data %>% read_html() %>% html_table() %>% .[[1]]
data_table = data_table %>%
  mutate(Date = as.Date(Date, format = "%B %d, %Y")) %>%
  set_colnames(c('Date', 'Value')) %>%
  tk_xts()
  
highchart(type = 'stock') %>%
  hc_add_series(data_table) %>%
  hc_scrollbar(enabled = TRUE)

# and more 
# https://www.multpl.com/sitemap

# Global CAPE
# https://www.starcapital.de/en/research/stock-market-valuation
library(jsonlite)
library(magrittr)
library(dplyr)
library(httr)
library(rvest)
library(tidyr)
library(tibble)
library(DT)

url = 'https://www.starcapital.de/fileadmin/charts/Res_Aktienmarktbewertungen_FundamentalKZ_Tbl.php?lang=en'
data = fromJSON(url)

col_name = data$cols$label

global_cape = data$rows %>% lapply(., data.frame) %>% .$c %>% t() %>% set_colnames(col_name) %>%
  data.frame() %>% set_rownames(NULL) %>%
  mutate_at(vars(-c('Country')), as.numeric) %>%
  arrange(Score)

head(global_cape)

global_cape %>% datatable()

# 세계 주요 주가지수
# https://www.investing.com/indices/major-indices

url = 'https://www.investing.com/indices/major-indices'
data = GET(url)
data_table = data %>% read_html() %>% html_table()
data_table[[1]] %>% select(Index, Last, `Chg. %`) %>%
  datatable()

# 차트 확인
# https://www.investing.com/indices/kospi
# Chart 들어감
# history? 

url = 'https://tvc4.forexpros.com/2869e95c1f9634478d6407ea20aa92aa/1612231146/1/1/8/history?symbol=37426&resolution=1&from=1612144753&to=1612231213'
data = fromJSON(url)
data = data %>% data.frame() %>% select(t, c, o, h, l) %>%
  mutate_all(as.numeric) %>%
  mutate(t = as.POSIXct(t, origin="1970-01-01"))

i = list(line = list(color = 'red'))
d = list(line = list(color = 'blue'))

data %>% 
  plot_ly(x = ~t, type="candlestick",
          open = ~data$o, close = ~data$c,
          high = ~data$h, low = ~data$l,
          increasing = i, decreasing = d) %>%
  layout(xaxis = list(title = NA),
         yaxis = list(title = '(%)'))

# Fear & Greed
# https://money.cnn.com/data/fear-and-greed/

library(rvest)
library(httr)
library(readr)
library(plotly)

url = 'https://money.cnn.com/data/fear-and-greed/'
web = GET(url)
fear_data = web %>% read_html() %>% html_nodes('#needleChart') %>%
  html_nodes('ul') %>%
  html_nodes('li') %>%
  html_text() 


plot_ly(
  domain = list(x = c(0, 1), y = c(0, 1)),
  value = fear_data[1] %>% parse_number,
  title = list(text = "Fear & Greed"),
  type = "indicator",
  mode = "gauge+number",
  gauge = list(
    axis = list(range = list(NULL, 100), tickwidth = 1, tickcolor = "black"),
    bar = list(color = "black"),
    bgcolor = "white",
    borderwidth = 2,
    bordercolor = "gray",
    steps = list(
      list(range = c(0, 10), color = "#ff1a1a"),
      list(range = c(10, 20), color = "#ff531a"),
      list(range = c(20, 30), color = "#ff8c1a"),
      list(range = c(30, 40), color = "#ffc61a"),
      list(range = c(40, 50), color = "#ffff1a"),
      list(range = c(50, 60), color = "#bfff00"),
      list(range = c(60, 70), color = "#80ff00"),
      list(range = c(70, 80), color = "#40ff00"),
      list(range = c(80, 90), color = "#00ff00"),
      list(range = c(90, 100), color = "#00ff40")
    ),
    threshold = list(
      line = list(color = "red", width = 4),
      thickness = 0.75,
      value = 80)) 
  ) %>%
  layout(margin = list(l=20,r=30),
         paper_bgcolor = "lavender")

