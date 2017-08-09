
# Problem 2
# recomen 폴더에 있는 데이터로 회귀 분석을 진행하려고 합니다.
#각 고객의 2015년 1월 간 구매 횟수를 Y로 하는 회귀 모델을 작성하세요.

library(DBI)
library(RSQLite)
library(bigrquery)
#con <- dbConnect(RSQLite::SQLite(), dbname="./class3assignment/class3assignment.sqlite")
#cusIDs <- dbGetQuery(con, "SELECT CAST(cusID AS CHAR) FROM tran WHERE date >= 20150101 AND date < 20150201")
#cusIDs <- unique(cusIDs)

project <- "dabrp-classnote2" 
cusIDs <- query_exec("SELECT cusID FROM [dabrp-classnote2:recom.tran] WHERE date >= 20150101 AND date < 20150201", project = project)
cusIDs <- unique(cusIDs)
Yvalue = c()
X1value = c()
X2value = c()
for(i in cusIDs[,1]){
  sql1 <- sprintf("SELECT SUM(time) FROM [dabrp-classnote2:recom.tran] WHERE date >= 20150101 AND date < 20150201 AND cusID==%s", i)
  sql2 <- sprintf("SELECT SUM(time) FROM [dabrp-classnote2:recom.tran] WHERE date >= 20141201 AND date < 20150101 AND cusID==%s", i)
  sql3 <- sprintf("SELECT SUM(time) FROM [dabrp-classnote2:recom.tran] WHERE date >= 20141101 AND date < 20141201 AND cusID==%s", i)
  Times <- query_exec(sql1, project = project)
  Yvalue <- c(Yvalue, Times$`SUM(time)`)
  Times <- query_exec(sql2, project = project)
  X1value <- c(X1value, Times$`SUM(time)`)
  Times <- query_exec(sql3, project = project)
  X2value <- c(X2value, Times$`SUM(time)`)
}

Yvalue = c()
X1value = c()
X2value = c()
######################################## 
for(i in cusIDs[,1]){
  Times <- dbGetQuery(con, sprintf("SELECT SUM(time) FROM tran WHERE date >= 20150101 AND date < 20150201 AND cusID==%s", i))
  Yvalue <- c(Yvalue, Times$`SUM(time)`)
  Times <- dbGetQuery(con, sprintf("SELECT SUM(time) FROM tran WHERE date >= 20141201 AND date < 20150101 AND cusID==%s", i))
  X1value <- c(X1value, Times$`SUM(time)`)
  Times <- dbGetQuery(con, sprintf("SELECT SUM(time) FROM tran WHERE date >= 20141101 AND date < 20141201 AND cusID==%s", i))
  X2value <- c(X2value, Times$`SUM(time)`)
}
cusIDs$Y <- Yvalue
cusIDs$X1 <- X1value
cusIDs$X2 <- X2value
customers <- data.frame(cusIDs, Yvalue, X1value, X2value)
names(customers) <- c("ID", "Y", "X1", "X2")
fit_2_1 <-lm(Y ~ X1 + X2, data=customers)

# Save raw data into DB
dbWriteTable(con, "class5_problem2_1", customers, overwrite=T)

dbListTables(conn = con)
load("./gsql.RData")

#각 고객의 2015년 1월 간 구매한 아이템의 종류를 Y로 하는 회귀 모델을 작성하세요.
for(i in cusIDs[,1]){
  sql1 <- sprintf("SELECT cate_3 FROM [dabrp-classnote2:recom.tran] WHERE date >= 20150101 AND date < 20150201 AND cusID==%s", i)
  sql2 <- sprintf("SELECT cate_3 FROM [dabrp-classnote2:recom.tran] WHERE date >= 20141201 AND date < 20150101 AND cusID==%s", i)
  sql3 <- sprintf("SELECT cate_3 FROM [dabrp-classnote2:recom.tran] WHERE date >= 20141101 AND date < 20141201 AND cusID==%s", i)
  Times <- query_exec(sql1, project = project)
  Yvalue <- c(Yvalue, Times$`SUM(time)`)
  Times <- query_exec(sql2, project = project)
  X1value <- c(X1value, Times$`SUM(time)`)
  Times <- query_exec(sql3, project = project)
  X2value <- c(X2value, Times$`SUM(time)`)
}
goods <- data.frame(cusIDs, Yvalue, X1value, X2value)
names(goods) <- c("ID", "Y", "X1", "X2")
fit_2_2 <-lm(Y ~ X1 + X2, data=goods)


######## Problem 3 #################################
#. ./recomen/tran.csv 데이터를 transactions 자료형에 맞게 입력해보세요
library(arules)

tran<-read.transactions("./recomen/tran.csv")
inspect(tran[1:10000,])
class(tran)
head(tran)
