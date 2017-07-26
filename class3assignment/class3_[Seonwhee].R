if (!require(devtools)) install.packages("devtools") 
if (!require(DBI)) devtools::install_github("rstats-db/DBI")
if (!require(RSQLite)) devtools::install_github("rstats-db/RSQLite")
if (!require(bigrquery)) devtools::install_github("rstats-db/bigrquery")
if (!require(data.table)) install.packages("data.table")
library(tidyverse)



#### Problem 1 ######
tran<-fread("./recomen/tran.csv")
head(tran)
Receipt_6998419 = filter(tran, receiptNum==6998419)

answer1 = sum(Receipt_6998419$amount)
answer1
####################
tran %>%
  filter(receiptNum=="6998419") %>%
  select(amount) %>%
  sum
####################
library(DBI)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), dbname="./recomen_data.sqlite")
dbWriteTable(con, "tran", tran, overwrite=T)
#### Problem 2 #####
item<-fread("./recomen/item.csv", encoding = "UTF-8")
head(item)
summary(tran$amount)
top_amount <- arrange(tran, amount)
dbWriteTable(con, "top_amount", top_amount, overwrite=T)
most_expensive_record <- tail(top_amount, n=1)
Partner_name = most_expensive_record$partner
category1 = most_expensive_record$cate_1
category2 = most_expensive_record$cate_2
category3 = most_expensive_record$cate_3

most_expensive_item <- filter(item, partner==Partner_name, cate_1==category1, cate_2==category2, cate_3==category3)
answer2 = most_expensive_item$cate_3_name
dbWriteTable(con, "answer2", most_expensive_item, overwrite=T)
answer2

### Problem 3 ######
chennel<-fread("./recomen/chennel.csv")
head(chennel)

Count_usage <- function(a_keyword){
  filtered_data = filter(chennel, strsplit(chennel, "_")[[1]][2] == a_keyword)
  summation = sum(filtered_data$useCnt)
  return(summation)
}
mobile_apps = Count_usage("MOBILE/APP")
online_mall = Count_usage("ONLINEMALL")

if (mobile_apps > online_mall){
  answer3 = "the most used channel is mobile apps"
} else if (mobile_apps < online_mall){
  answer3 = "the most used channel is online mall"
} else{
  answer3 = "the number of mobile apps users and online mall users are the same"
}
answer3

#### Problem 4 #######################

subDF <- dbGetQuery(con, "SELECT * FROM tran WHERE date >= 20150301 AND date < 20150401")
dbWriteTable(con, "tran2015_03", subDF, overwrite=T)
group_name = dbGetQuery(con, "SELECT * FROM tran2015_03 GROUP BY storeCode, amount")
StoreCODE <- unique(group_name$storeCode)
j = 1
store = c()
summation = c()
for(i in StoreCODE){
  aStore <- filter(group_name, storeCode==i)
  store[j] <- i
  summation[j] <- (sum(aStore$amount))
  j = j + 1
}
answer4 <- data.frame(storeCode = store, total_revenue = summation)
dbWriteTable(con, "answer4", answer4, overwrite=T)
answer4 <- arrange(answer4, total_revenue)
tail(answer4, n=1)

### Problem 5 ######################
competitor<-fread("./recomen/competitor.csv")
customer<-fread("./recomen/customer.csv", encoding = "UTF-8")
head(competitor)
head(customer)
CustomerIDs <- unique(competitor$cusID)
num_use = c()
id = c()
i = 1
for(cus in CustomerIDs){
  customer_record <- filter(competitor, cusID==cus)
  num_use[i] <- (dim(customer_record)[1])
  id[i] <- cus
  i = i + 1
}
Customer_list = data.frame(cusID = id, number_use = num_use)
dbWriteTable(con, "answer5", Customer_list, overwrite=T)
Customer_list <- arrange(Customer_list, number_use)
VVIP = tail(Customer_list, n=1)
VVIP_info <- filter(customer, cusID==VVIP$cusID)
answer5 = VVIP_info$sex

### Problem 6 ############################
cusIDs <- unique(tran$cusID)
stores <- unique(tran$storeCode)
Dates <- unique(tran$date)
favorite_goods = c()
i = 1
#### too much time spending !!!!! more than 3 hours ###########
for(cus in cusIDs){
 for(sto in stores){
   for(dat in Dates){
       goods_record <- filter(tran, cusID==cus, storeCode==sto, date==dat)
       if(dim(goods_record)[1] >= 3){
         favorite_goods[i] <- goods_record$cate_3
         i = i+1
       }
     }
   }
}