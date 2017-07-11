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
con <- dbConnect(RSQLite::SQLite(),
                 dbname="class3hw.sqlite")

## get data

chk<-file.info("./recomen/tran.csv")
if(is.na(chk$size)){
  recoment<-"http://rcoholic.duckdns.org/oc/index.php/s/jISrPutj4ocLci2/download"
  dir.create("./recomen", showWarnings = F)
  download.file(recoment,destfile="./recomen/tran.csv",mode='wb')
}

## load data to R

library(readr)
library(tidyverse)
library(dplyr)
library(data.table)

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

#1번 문제
tran_ama = tran %>%
  filter(receiptNum==6998419) %>%
  select(receiptNum, amount)
tran_ama
summary(tran_ama)
sum(tran_ama$amount)
# answer : 154,121


#2번 문제
summary(tran)
# amount의 max=101,330,000
tran_max=filter(tran, amount==101330000)
tran_max
# amount의 max=101,330,000일 때의 cate_3="A080106"
item_f=filter(item, cate_3=="A080106")
item_f
# answer : 명품(명품잡화)


#3번 문제
chennel_A=filter(chennel, chennel=="A_MOBILE/APP")
chennel_B=filter(chennel, chennel=="B_ONLINEMALL")
summary(chennel_A)
summary(chennel_B)
#answer : MOBILE/APP


#4번 문제 
tran_mar=filter(tran, date %in% c(20150301, 20150331))
tran_mar
#2015년 3월 데이터만 뽑아내기
summary(tran_mar)
by_store <- group_by(tran_mar, storeCode)
class(by_store)
tran_store=summarise(by_store, amount_storer = sum(amount, na.rm = FALSE))
summary(tran_store)
filter(tran_store, amount_storer==220710545)
#answer : 00002번 store


#5번 문제
customer_01=competitor %>%
  left_join(customer, by="cusID") %>%
  select(cusID, partner, competitor, useDate, sex)

customer_M=customer_01 %>%
  filter(sex=="M") %>%
  summarise(sex = n())
customer_M
customer_F=customer_01 %>%
  filter(sex=="F") %>%
  summarise(sex = n())
customer_F
#answer : Female


#6번은 너무 어려워서 하지 못했습니다.....ㅠㅠ