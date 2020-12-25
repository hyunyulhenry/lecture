library(readr)
library(readxl)
library(dplyr)
library(ggplot2)
library(magrittr)
library(tidyr)
library(moments)
library(extrafont)

font_add(family = 'NanumGothic', regular = 'NanumFont/NanumGothic.ttf')
showtext_auto()

trace(grDevices::png, exit = quote({
  showtext::showtext_begin()
}), print = FALSE)

# K200 --------------------------------------------------------------------

K200 = read_excel('data/K200.xls')
K200 = K200 %>%
  filter(`시간` != 'CLS') %>%
  mutate('K200' = as.numeric(현재지수) / as.numeric(전일지수) - 1) %>%
  select(시간, K200) %>%
  group_by(시간) %>%
  slice(n()) %>%
  ungroup()


# KODEX 200 ---------------------------------------------------------------

KODEX_200 = read_csv('data/KODEX 200.csv')
KODEX_200 = KODEX_200 %>%
  mutate(전일 = 체결가 - 대비,
           KODEX_200 = 체결가 / 전일 - 1) %>%
  select(시간, KODEX_200) %>%
  group_by(시간) %>%
  slice(n()) %>%
  ungroup()


# K200 FUTURE -------------------------------------------------------------

K200_F = read_csv('data/K200_F.csv')
K200_F = K200_F %>%
  mutate(K200_F = 현재지수 / 전일지수 - 1) %>%
  select(시간, K200_F) %>%
  group_by(시간) %>%
  slice(n()) %>%
  ungroup()


# K200 Fut 2X -------------------------------------------------------------

K200_F_2X = K200_F %>%
  mutate(K200_F_2X = K200_F * 2) %>%
  select(-K200_F)


# K200 Fut -1X ------------------------------------------------------------

K200_F_inv = K200_F %>%
  mutate(K200_F_inv = K200_F * -1) %>%
  select(-K200_F)
  
# K200 Fut -2X ------------------------------------------------------------

K200_F_inv_2X = K200_F %>%
  mutate(K200_F_inv_2X = K200_F * -2) %>%
  select(-K200_F)

# KODEX 인버스 ---------------------------------------------------------------

KODEX_inv = read_csv('data/KODEX 인버스.csv')
KODEX_inv = KODEX_inv %>%
  mutate(전일 = 체결가 - 대비,
           KODEX_inv = 체결가 / 전일 - 1) %>%
  select(시간, KODEX_inv) %>%
  group_by(시간) %>%
  slice(n()) %>%
  ungroup()


# KODEX 레버리지 --------------------------------------------------------------

KODEX_레버리지 = read_csv('data/KODEX 레버리지.csv')
KODEX_레버리지 = KODEX_레버리지 %>%
  mutate(전일 = 현재가 - 전일대비,
           KODEX_레버리지 = 현재가 / 18610 - 1) %>%
  select(시간, KODEX_레버리지) %>%
  group_by(시간) %>%
  slice(n()) %>%
  ungroup()


# KODEX 200선물인버스2X --------------------------------------------------------

KODEX_곱버스 = read_csv('data/KODEX 200선물인버스2X.csv')
KODEX_곱버스 = KODEX_곱버스 %>%
  mutate(전일 = 현재가 - 전일대비,
           KODEX_곱버스 = 현재가 / 3240 - 1) %>%
  select(시간, KODEX_곱버스) %>%
  group_by(시간) %>%
  slice(n()) %>%
  ungroup()


# 함수 만들기 ------------------------------------------------------------------

result = function(a, b) {
  
  join = a %>% full_join(b, by = '시간') %>%
    arrange(시간) %>%
    mutate(시간 = as.character(시간)) %>%
    filter(시간 <= '15:20:00')
  
  join = join %>% fill(colnames(join)[2]) %>%
    fill(colnames(join)[3]) %>%
    na.omit() %>%
    mutate(차이 =  .[[2]] - .[[3]])
  
  result = list()
    
  result[[1]] = join %>%
    gather(key, value, -시간) %>%
    ggplot(aes(x = 시간, y = value, group = key)) +
    geom_line(aes(color = key)) +
    theme(legend.title = element_blank(),
          legend.position = "bottom")
  
  result[[2]] = join %>%
    filter(시간 >= '09:01:00') %>%
    select(시간, 차이) %>%
    ggplot(aes(x = 시간, y = 차이)) +
    geom_line(group = 1) +
    theme(legend.title = element_blank(),
          legend.position = "bottom")
  
  result[[3]] = join %>%
    filter(시간 >= '09:01:00') %>%
    ggplot(aes(x = 차이)) +
    geom_histogram() +
    theme(legend.title = element_blank(),
          legend.position = "bottom")
  
  result[[4]] = join %>%
    filter(시간 >= '09:01:00') %>%
    mutate(차이 = abs(차이)) %>%
    summarize(max(차이), min(차이), mean(차이), 
              kurtosis(차이)) 
  
  return(result)
  
}


# 결과 ----------------------------------------------------------------------

result(K200, KODEX_200)
result(K200_F_2X, KODEX_레버리지)

result(K200_F_inv, KODEX_inv)
result(K200_F_inv_2X, KODEX_곱버스)
