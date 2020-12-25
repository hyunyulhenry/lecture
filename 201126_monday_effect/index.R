library(readxl)
library(timetk)
library(lubridate)

raw = read_excel('futures.xlsx')

head(raw, 15)

data = raw %>% slice(-1:-13) %>%
  set_names(c('Date', 'KS200_Op', 'KS200_Cl', 'KQ150_Op', 'KQ150_Cl')) %>%
  mutate_all(as.numeric) %>%
  mutate(Date = as.Date(Date, origin = '1899-12-30')) 

data = data %>%
  mutate(KS200_gap = KS200_Op / lag(KS200_Cl) - 1,
         KQ150_gap = KQ150_Op / lag(KQ150_Cl) - 1)

# floor_date(data$Date, "weeks", week_start = 1) %>% unique() %>% View()

data = data %>%
  mutate(day = weekdays(Date)) %>%
  filter(day == 'Monday')
