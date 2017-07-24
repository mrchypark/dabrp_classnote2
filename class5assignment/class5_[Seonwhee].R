
# Problem 2
# recomen 폴더에 있는 데이터로 회귀 분석을 진행하려고 합니다.
#각 고객의 2015년 1월 간 구매 횟수를 Y로 하는 회귀 모델을 작성하세요.
#각 고객의 2015년 1월 간 구매한 아이템의 종류를 Y로 하는 회귀 모델을 작성하세요.
#위에 두 문제 모두 X에 대해서 선정하고 그 이유를 설명해 주세요.

library(DBI)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), dbname="./class3assignment/class3assignment.sqlite")
cusIDs <- dbGetQuery(con, "SELECT CAST(cusID AS CHAR) FROM tran WHERE date >= 20150101 AND date < 20150201")
cusIDs <- unique(cusIDs)

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
#### Due to the limitation of calculation time, we only get the first 12998 customers' purchasing time   
customers <- data.frame(cusIDs[1:12998,1], Yvalue, X1value, X2value)
names(customers) <- c("ID", "Y", "X1", "X2")
fit_2_1 <-lm(Y ~ X1 + X2, data=customers)

# Save raw data into DB
dbWriteTable(con, "class5_problem2_1", customers, overwrite=T)

dbListTables(conn = con)
