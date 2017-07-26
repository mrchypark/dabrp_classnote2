if (!require(tidyverse)) install.packages("tidyverse") 
if (!require(data.table)) install.packages("data.table") 
if (!require(arules)) install.packages("arules") 
library(tidyverse)
library(data.table)
library(arules)

chen<-fread("./recomen/chennel.csv")
comp<-fread("./recomen/competitor.csv")
cust<-fread("./recomen/customer.csv", encoding = "UTF-8")
item<-fread("./recomen/item.csv", encoding = "UTF-8")
memb<-fread("./recomen/membership.csv", encoding = "UTF-8")
tran<-fread("./recomen/tran.csv")

# 1 k-means

chen
comp
cust
item
memb
tran

# 2 회귀분석

chen
comp
cust
item
memb
tran

# 3. transactions

tem <- as.data.frame(tran[1:100000, ])
te <- as(split(tem[,"cate_3"], tem[,c("receiptNum")]), "transactions")
te <- as(split(tran[,"cate_3"], tran[,c("receiptNum")]), "transactions")

# list

# factor