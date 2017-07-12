
chk<-file.info("./recomen/tran.csv")
if(is.na(chk$size)){
  recoment<-"http://rcoholic.duckdns.org/oc/index.php/s/jISrPutj4ocLci2/download"
  dir.create("./recomen", showWarnings = F)
  download.file(recoment,destfile="./recomen/tran.csv",mode='wb')
}

if (!require(data.table)) install.packages("data.table")
if (!require(tidyverse)) install.packages("tidyverse")

library(readr)
library(tidyverse)
library(dplyr)
#library(RSQLite)
library(data.table)



#read data

tran <- read.csv('./recomen/tran.csv', header = TRUE)
membership <- read_csv('./recomen/membership.csv')
item <- read_csv('./recomen/item.csv')
customer <- read_csv('./recomen/customer.csv')
competitor <- read.csv('./recomen/competitor.csv', header = TRUE)
chennel <- read.csv('./recomen/chennel.csv', header = TRUE)

#summary data

str(tran)
str(item)
str(membership)
str(custormer)
str(competitor)
str(chennel)



#1.receiptNum가 "6998419"인 구매기록의 가격(amout)의 합은 얼마인가요?

Problom_1 <- tran %>% 
  filter(receiptNum == "6998419") %>%
  summarize(sum = sum(amount))
  
Problom_1 #154121


#2.가장 비싼 item은 무엇인가요?


summary(as.factor(item$partner))
summary(as.factor(tran$partner))

Problom_2 <- tran %>%
  filter(amount == max(amount)) %>%
  select(cate_1, cate_2, cate_3) %>%
  merge(item[, c('cate_3', 'cate_2_name', 'cate_3_name')], by = 'cate_3', all.x = TRUE)

Problom_2 #명품잡화


#3.사용자들이 가장 많이 사용한 체널은 mobile/app과 onlinemall 중에 무엇입니까?

summary(as.factor(chennel$chennel))

Problom_3 <- chennel %>%
  separate(chennel, into = c("parter", "chennel_2"), sep = "_")  %>%
  group_by(chennel_2) %>%
  summarize(sum = sum(useCnt))

Problom_2 #106988인 Mobile/App


#4.월매출이 2015년 03월 가장 높은 매장의 storeCode는 무엇인가요?


Problom_4 <- tran %>%
  mutate(month = paste0(substr(date,1,4),'-',substr(date,5,6))) %>%
  group_by(month) %>%
  summarize(monthly_sum = sum(amount)) %>%
  filter(monthly_sum == max(monthly_sum))
         
Problom_4 #106988인 Mobile/App


#5.경쟁사의 이용기록이 가장 많은 사용자의 성별은 무엇입니까? (competitor 데이터에서 1row가 1건이라고 가정)

summary(as.factor(competitor$cusID))
summary(as.factor(competitor$competitor))

Problom_5.1 <- competitor %>%
  group_by(cusID) %>%
  summarize(count = n())

Problom_5.2 <- Problom_5.1[which.max(Problom_5.1$count),] %>%
  merge(customer, by = 'cusID', all.x = TRUE)

Problom_5.2 #sex = M


#6.한번에 3개 이상 구매한 경우에 가장 많이 구매에 포함된 제품 카테고리(cate_3)는 무엇입니까?

setDT(tran)[,Item_Num:=.GRP, by =receiptNum]

memory.size()
memory.limit(398100)
tran <- data.frame(tran)

Problom_6.1 <- tran %>%
  filter(Item_Num >= 3) %>%
  group_by(cate_3) %>% 
  summarize(count = n())  

Problom_6.2 <- Problom_6.1[which.max(Problom_6.1$count),] %>%
  merge(item[,c('cate_3','cate_2_name','cate_3_name')], by = 'cate_3', all.x = TRUE)

Problom_6.2 #일반흰우유
