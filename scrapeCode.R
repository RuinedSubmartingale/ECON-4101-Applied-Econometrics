# TODO: abstract scrapeData.R and scrapeCode.R
require(rvest)
require(stringr)
code_dir_html <- 'http://evansresearch.us/DSC/Spring2017/ECMT/Code/'
code_names <- read_html(code_dir_html) %>% html_nodes("a") %>% html_attr('href') %>% str_subset('.R$')
code_links <- paste0(code_dir_html, code_names)
names(code_links) <- code_names
# m <- regexpr('(?<=/)[^/]*$', code_links, perl = T)
# regmatches(code_links, m)
for (dn in code_names) {
  destfile <- paste0('./Code/', dn)
  if (!file.exists(destfile)) {
    # browser()
    download.file(code_links[dn], destfile)
  }
}
