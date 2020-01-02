library(rvest)
library(httr)
library(stringr)
library(dplyr)

n = 3
url = 'http://cran-logs.rstudio.com/'
data = GET(url) %>%
  read_html() %>%
  html_nodes('a') %>%
  html_attr('href')

data = data %>% str_match("[0-9]+/[0-9]+-[0-9]+-[0-9]+.csv.gz") %>% 
  na.omit() %>% tail(n)

log_folder = tempdir()

for (i in data) {
  
  name = i %>% str_remove_all("[0-9]+/")
  download.file(paste0(url, i),
                destfile = paste0(log_folder, '/', name), mode = 'wb')
}

avilable_files = list.files(log_folder)
avilable_files = avilable_files %>% str_match("[0-9]+-[0-9]+-[0-9]+.csv.gz") %>%
  na.omit()

logs <- list()
for (file in avilable_files) {
  logfile = read.table(paste0(log_folder, '/', file), header = TRUE, sep = ",", quote = "\"",
                       dec = ".", fill = TRUE, stringsAsFactors = FALSE,
                       comment.char = "", as.is=TRUE)
  # package <- logfile$package
  logs[[file]] <- logfile
}

logs = bind_rows(logs)
tbl = logs %>% group_by(package) %>%
  count() %>% ungroup() %>% arrange(desc(n)) %>% top_n(100)

write.csv(tbl, 'popular.csv')