if (!require(devtools)) install.packages("devtools") 
if (!require(DBI)) devtools::install_github("rstats-db/DBI")
if (!require(RSQLite)) devtools::install_github("rstats-db/RSQLite")
if (!require(RMySQL)) devtools::install_github("rstats-db/RMySQL")
if (!require(bigrquery)) devtools::install_github("rstats-db/bigrquery")
if (!require(data.table)) install.packages("data.table")
if (!require(readr)) install.packages("readr")


## DBI

library(DBI)
library(RSQLite)

## get data

chk<-file.info("./recomen/tran.csv")
if(is.na(chk$size)){
  recoment<-"http://rcoholic.duckdns.org/oc/index.php/s/jISrPutj4ocLci2/download"
  dir.create("./recomen", showWarnings = F)
  download.file(recoment,destfile="./recomen/tran.csv",mode='wb')
}

## load data to R

library(readr)

#readr library에 tibble 명령어가 포함되어 있음
chennel<-read_csv("./recomen/chennel.csv")
competitor<-read_csv("./recomen/competitor.csv")
customer<-read_csv("./recomen/customer.csv")
item<-read_csv("./recomen/item.csv")
membership<-read_csv("./recomen/membership.csv")
tran<-read_csv("./recomen/tran.csv")

chennel
competitor
customer
item
membership
tran
