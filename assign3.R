if (!require(devtools)) install.packages("devtools") 
if (!require(DBI)) devtools::install_github("rstats-db/DBI")
if (!require(RSQLite)) devtools::install_github("rstats-db/RSQLite")
if (!require(bigrquery)) devtools::install_github("rstats-db/bigrquery")
if (!require(data.table)) install.packages("data.table")
library(tidyverse)

# 파일을 불러옵니다.

chen<-fread("./recomen/chennel.csv")
comp<-fread("./recomen/competitor.csv")
cust<-fread("./recomen/customer.csv", encoding = "UTF-8")
item<-fread("./recomen/item.csv", encoding = "UTF-8")
memb<-fread("./recomen/membership.csv", encoding = "UTF-8")
tran<-fread("./recomen/tran.csv")

# 내용을 확인합니다.

chen
comp
cust
item
memb
tran

# 다루기 좋은 방향으로 컬럼들을 정리합니다.
# ID는 5자리 숫자모양의 char로 정리합니다.
# area의 경우도 3자리 ID로 보여 3자리 숫자모양의 char로 정리합니다.
chen$cusID   <- sprintf("%05d",chen$cusID)
comp$cusID   <- sprintf("%05d",comp$cusID)
cust$cusID   <- sprintf("%05d",cust$cusID)
cust$area    <- sprintf("%03d",cust$area)
memb$cusID   <- sprintf("%05d",memb$cusID)

# 날짜는 Date 자료형으로 바꾸는데, 자신이 익숙한 방법을 사용하면 좋습니다.
# lubridate를 사용하는 방법, year, month, day로 컬럼을 쪼개는 방법등 다양하게 있습니다.
# 저는 Date 자료형을 사용하는 방법이 나중에 ggplot 그리기도 좋아서 선호합니다.

memb$regDate <- 
  memb$regDate %>% 
  paste0(.,"01") %>%
  as.Date(format="%Y%m%d")

# factor로 할만한 변수들이 있는지 확인합니다.
unique(memb$memberShip)

# 큰 파일은 작은 샘플을 만들어서 전처리를 진행해보고 코드를 적용합니다.
# tem<-tran[1:10]

tran[,receiptNum:=as.character(receiptNum)]
tran[,storeCode:=as.character(storeCode)]
tran[,amount:=as.numeric(amount)]
tran[,cusID:=sprintf("%05d",cusID)]
tran[,date:=as.Date(as.character(date), format="%Y%m%d")]



## receiptNum가 "6998419"인 구매기록의 가격(amout)의 합은 얼마인가요?
sum(tran[receiptNum=="6998419",amount])

# #가장 비싼 item은 무엇인가요?

# "select b.partner, b.cate_3, b.amount 
# from
# (select max(amount) as max from [konlper-168808:recomen.tran]) as a 
# inner join 
# [konlper-168808:recomen.tran] as b on 
# a.max=b.amount"

## sql 답
## 최대값에 해당하는 row를 바로 호출할 수 없어서 join으로 우회
"select b.partner, b.cate_3, b.amount 
from (select max(amount) as max from tran) as a 
inner join 
tran as b 
on 
a.max=b.amount"

# dplyr tidyr 답
# filter로 amount 중 최대값인 부분을 찾음
# 그리고 partner와 cate_3 컬럼을 select로 지정
tar <- 
  tran %>%
  filter(amount==max(amount)) %>%
  select(partner,cate_3)
# item에서 partner와 cate_3이 같은 내용을 찾음
item %>%
  filter(partner==tar$partner,cate_3==tar$cate_3)

# data.table 답 
# 위 내용과 같음
tar<-tran[amount==max(tran$amount),.(partner,cate_3)]
item[partner==tar$partner&cate_3==tar$cate_3]

## 사용자들이 가장 많이 사용한 체널은 mobile/app과 onlinemall 중에 무엇입니까?

# sql 답
# 조건을 줘서 각각 따로 계산함
"SELECT sum(useCnt) FROM chennel WHERE chennel LIKE '%MOBILE%'"
"SELECT sum(useCnt) FROM chennel WHERE chennel LIKE '%ONLINE%'"

# dplyr tidyr 답
# chennel에서 앞의 ABCD 부분을 분리해내고,
# mobile/app과 onlinemall 만 남은 chennel 컬럼으로 그룹을 묶어
# 합을 계산하여 확인
chen %>%
  separate(chennel, into=c("partner","chennel"), sep="_") %>%
  group_by(chennel) %>%
  summarise(sum(useCnt))

# data.table 답
# che라고 하는 새로운 컬럼을 생성하여 계산후 제거
chen[,che:=ifelse(grepl("APP",chennel),"mob","online")]
chen[,sum(useCnt),by=.(che)]
chen[,che:=NULL]

## 월매출이 2015년 03월 가장 높은 매장의 storeCode는 무엇인가요?

# sql 답


# dplyr tidyr 답
tran %>%
  filter(date>=as.Date("2015-03-01"),date<=as.Date("2015-03-31")) %>%
  group_by(storeCode) %>%
  summarise(sum(amount)) %>%
  arrange(desc(`sum(amount)`))

# data.table 답
tran[date>=as.Date("2015-03-01")&date<=as.Date("2015-03-31"),sum(amount),by=.(storeCode)][order(V1,decreasing = T)]

## 경쟁사의 이용기록이 가장 많은 사용자의 성별은 무엇입니까?
## competitor 데이터에서 1row가 1건이라고 가정

# dplyr tidyr 답
# competitor 에서 cusID를 기준으로 갯수를 세서 가장 많은 개수인 cusID를 찾아서
# customer의 cusID와 일치하는 것을 보여줌
tar <-
  comp %>%
  group_by(cusID) %>%
  summarise(n()) %>%
  filter(`n()`==max(`n()`)) %>%
  select(cusID)
cust[cusID==tar,]

# data.table 답
cust[cusID==comp[,.N,by=.(cusID)][N==max(N),cusID]]

## 한번에 3개 이상 구매한 경우에 가장 많이 구매에 포함된 제품 카테고리(cate_3)는 무엇입니까?

# dplyr tidyr 답
devtools::install_github("tidyverse/dbplyr")
library(dplyr)
library(bigrquery)

con <- DBI::dbConnect(dbi_driver(),
  project = "konlper-168808",
  dataset = "recom",
  billing = "konlper-168808"
)

DBI::dbListTables(con)

tran <- con %>% tbl("tran")
tran

tem<-tran %>% 
  group_by(receiptNum) %>%
  summarise(total = n()) %>%
  filter(total>2) %>%
  select(receiptNum)

tar<-tran %>%
  semi_join(tem)

cid<-tar %>%
  group_by(cate_3) %>%
  summarise(total = n()) %>%
  arrange(total) %>%
  filter(1) %>%
  select(cate_3)

item[cate_3==cid]

# data.table 답
tem<-tran[,.N,by=.(receiptNum)]
tar<-tran[receiptNum %in% tem[N>2,receiptNum]]
cid<-tar[,.N,by=.(cate_3)][order(N, decreasing = T)][1,cate_3]
item[cate_3==cid]


