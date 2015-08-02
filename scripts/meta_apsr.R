"
Meta APSR
Recode the data
Run some data quality checks (more needed)

"

# Load libs
library(ggplot2)
# devtools::install_github("soodoku/goji")
library(goji)
library(plyr)

# setwd
setwd(githubdir)
setwd("meta_apsr/")

# Read in data
apsr <- read.csv("data/apsr_data.csv")

"
Recoding
"

# Issue
apsr$issue <- paste0(apsr$issue.date.of.publication, apsr$issue.volume)

# Volume start and end pages
apsr$volume.start.page <- sapply(strsplit(apsr$issue.pages, "-"), "[")[1,]
apsr$volume.end.page <- sapply(strsplit(apsr$issue.pages, "-"), "[")[2,]

# Volume page length
# Fix 1916
apsr$volume.end.page[apsr$volume.end.page==33 & apsr$issue.year==1916] <- "433"
apsr$volume.page.length <- as.numeric(apsr$volume.end.page) - as.numeric(apsr$volume.start.page)

# Article start and end pages
# Take out one place where length n.e. 2
apsr <- subset(apsr, sapply(sapply(strsplit(apsr$article.pages, "-"), "["), length)==2)

apsr$article.start.page <- sapply(strsplit(apsr$article.pages, "-"), "[")[1,]
apsr$article.end.page <- sapply(strsplit(apsr$article.pages, "-"), "[")[2,]

# Notes to editor etc. with non-numeric pages. Coerce
apsr$article.page.length <- as.numeric(apsr$article.end.page) - as.numeric(apsr$article.start.page)

# No. of authors
apsr$n.authors <- rowSums(!is.na(apsr[,paste0("author", 1:10)]) & apsr[,paste0("author", 1:10)]!="")

# Date issues as always
apsr$issue.year <- year(as.POSIXlt(apsr$issue.year, format="%Y"))

# Do some data quality checks .....
# Too many articles
apsr <- subset(apsr, !is.na(article.page.length) & !is.na(volume.page.length)) 
apsr <- subset(apsr, n.authors > 0)		   # Editor note etc.
apsr <- subset(apsr, article.abstract!="") # No abstract
apsr <- subset(apsr, article.page.length > 1) # it appears articles shorter than this are rejoinders etc.
