# TODO: abstract scrapeData.R and scrapeCode.R
require(rvest)
require(stringr)
data_dir_html <- 'http://evansresearch.us/DSC/Spring2017/ECMT/Data/'
data_names <- read_html(data_dir_html) %>% html_nodes("a") %>% html_attr('href') %>% str_subset('.csv|.xls|.xlsx$')
data_links <- paste0(data_dir_html, data_names)
names(data_links) <- data_names
# m <- regexpr('(?<=/)[^/]*$', data_links, perl = T)
# regmatches(data_links, m)
for (dn in data_names) {
  destfile <- paste0('./Data/', dn)
  if (!file.exists(destfile)) {
    # browser()
    download.file(data_links[dn], destfile)
  }
}

data_dir_html <- 'http://evansresearch.us/DSC/Spring2017/ECMT/Data_Woolridge/'
data_names <- read_html(data_dir_html) %>% html_nodes("a") %>% html_attr('href') %>% str_subset('.csv|.xls|.xlsx$')
data_links <- paste0(data_dir_html, data_names)
names(data_links) <- data_names
# m <- regexpr('(?<=/)[^/]*$', data_links, perl = T)
# regmatches(data_links, m)
for (dn in data_names) {
  destfile <- paste0('./Data_Woolridge/', dn)
  if (!file.exists(destfile)) {
    # browser()
    download.file(data_links[dn], destfile)
  }
}
