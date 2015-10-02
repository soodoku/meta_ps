"
Meta APSR
Recode the data
Run some data quality checks (more needed)

"

# Load libs
# devtools::install_github("soodoku/goji")
library(goji)
library(plyr)
library(ggplot2)
library(grid)
library(lubridate)

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

# Author Gender 
# Gender
library(gender)
# Only has data till 2012

apsr$firstname_author1  <- sapply(strsplit(apsr$author1, " "), "[", 1)
apsr$firstname_author2  <- sapply(strsplit(apsr$author2, " "), "[", 1)
apsr$firstname_author3  <- sapply(strsplit(apsr$author3, " "), "[", 1)
apsr$firstname_author4  <- sapply(strsplit(apsr$author4, " "), "[", 1)
apsr$firstname_author5  <- sapply(strsplit(apsr$author5, " "), "[", 1)
apsr$firstname_author6  <- sapply(strsplit(apsr$author6, " "), "[", 1)
apsr$firstname_author7  <- sapply(strsplit(apsr$author7, " "), "[", 1)

apsr[,paste0("gender_author", 1:7)] <- NA

# Gender pkg issues
# ~~ Taking age uniform b/w 25 to 65 yrs
# ~~~ 1880 to 2012
# ~~~ ceiling of year range when it bumps against the bottom--- not appetizing but probably that big a deal; people can investigate

for (i in 1:nrow(apsr)){
	
	lowerbound <- ifelse(apsr$issue.year[i] - 65 < 1880, 1880, apsr$issue.year[i] - 65)
	apsr$gender_author1[i] <- ifelse(is.na(apsr$firstname_author1[i]), NA, gender(apsr$firstname_author1[i], c(lowerbound, apsr$issue.year[i] - 25))$proportion_female)
	apsr$gender_author2[i] <- ifelse(is.na(apsr$firstname_author2[i]), NA, gender(apsr$firstname_author2[i], c(lowerbound, apsr$issue.year[i] - 25))$proportion_female)
	apsr$gender_author3[i] <- ifelse(is.na(apsr$firstname_author3[i]), NA, gender(apsr$firstname_author3[i], c(lowerbound, apsr$issue.year[i] - 25))$proportion_female)
	apsr$gender_author4[i] <- ifelse(is.na(apsr$firstname_author4[i]), NA, gender(apsr$firstname_author4[i], c(lowerbound, apsr$issue.year[i] - 25))$proportion_female)
	apsr$gender_author5[i] <- ifelse(is.na(apsr$firstname_author5[i]), NA, gender(apsr$firstname_author5[i], c(lowerbound, apsr$issue.year[i] - 25))$proportion_female)
	apsr$gender_author6[i] <- ifelse(is.na(apsr$firstname_author6[i]), NA, gender(apsr$firstname_author6[i], c(lowerbound, apsr$issue.year[i] - 25))$proportion_female)
	apsr$gender_author7[i] <- ifelse(is.na(apsr$firstname_author7[i]), NA, gender(apsr$firstname_author7[i], c(lowerbound, apsr$issue.year[i] - 25))$proportion_female)
}

apsr$avg_gender <- with(apsr, rowSums(cbind(gender_author1, gender_author2, gender_author3, gender_author4, gender_author5, gender_author6, gender_author7), na.rm=T))/apsr$n.authors

# Length of title
# Some serious issues: apsr$article.title[apsr$title_len > 200]
apsr$title_len <- nchar(apsr$article.title)
