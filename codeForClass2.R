## set packages 패키지가 없으면 다운로드하는 명령어
## devtools는 github에 올라와있는 패키지이므로 항시 업데이트되어 사용할 수 있도록 하고 있음
## devtools::로 devtools내의 세부패키지를 설정

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
con <- dbConnect(RSQLite::SQLite(), dbname="class2.sqlite")
# class2.sqlite라는 이름의 파일이 생성됨


# check db tables
dbListTables(con)


# write table to db
dbWriteTable(con, "mtcars", mtcars, overwrite=T)
#mtcars라는 데이터를 불러와서 class2.sqlite 파일 내에 저장함. 
#이 경우 현재의 mtcars에 rowname으로 지정된 차이름이 ID로 적절하지 않아 임의로 숫자로 ID를 지정함
#해당 행위를 dbwriteTable 명령어가 알아서 지정해서 파일에 저장
dbListTables(con)
identical(dbReadTable(con,"mtcars"),mtcars) ##That two files are same -> "True"
#dbwriteTable의 임의 ID지정으로 인해 False가 결과로 나오

# get table data
dbReadTable(con, "mtcars")


# remove
dbRemoveTable(con,"mtcars")
dbListTables(con)


# you can write table from file directly.
system.time(dbWriteTable(con, "member", "./recomen/membership.csv",row.names=F))


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


## head

chennel
competitor
customer
item
membership
tran


## control print row count

options(tibble.print_min = 10)
#현재 tibble은 기본 설정이 10개 db를 보여주는데 그 수치를 위 명령어로 변경할 수 있음
item


## tail

tail(chennel)
tail(competitor)
tail(customer)
tail(item)
tail(membership)
tail(tran)


## get data summary

summary(chennel)
summary(competitor)
summary(customer)
summary(item)
summary(membership)
summary(tran)


## get data structure

str(chennel)
str(competitor)
str(customer)
str(item)
str(membership)
str(tran)
#factor형 column의 경우 각 요소별 크기를 지정하는 기능도 있음



# 


## set Mysql with google cloud
# ctrl + shift + c : 주석처리를 한번에 할 수있는 단축

# user<-"root"
# pw<-"XXXXXXXXXXXXXXXXX"
# host<-'XXX.XXX.XXX.XXX'
#rm(pw)
#rm(host)
#save(user,pw,host,file ="./gsql.RData")

load("./gsql.RData")

library(RMySQL)
con <- dbConnect(MySQL(),
                 user = user,
                 password = pw,
                 host = host,
                 dbname = "recom")
dbListTables(conn = con)
dbWriteTable(conn = con, name = 'chennel', value = "./recomen/chennel.csv")
dbReadTable(conn = con, name = "Test")

## for bigquery query

# select title,sum(num_characters) as num_characters
# from [konlper-168808:test.wikipedia_copy]
# where regexp_match(title,'[Ss]eoul')
# group by title
# order by num_characters desc;

library(bigrquery)
project <- "konlper-168808" 
sql <- "SELECT * FROM [konlper-168808:recom.chennel] LIMIT 5"
=======
## set packages

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
con <- dbConnect(RSQLite::SQLite(), dbname="class2.sqlite")


# check db tables
dbListTables(con)


# write table to db
dbWriteTable(con, "mtcars", mtcars, overwrite=T)
dbListTables(con)


# get table data
dbReadTable(con, "mtcars")


# remove
dbRemoveTable(con,"tran")
dbListTables(con)


# you can write table from file directly.
system.time(dbWriteTable(con, "member", "./recomen/membership.csv",row.names=F))


## get data

chk<-file.info("./recomen/tran.csv")
if(is.na(chk$size)){
  recoment<-"http://rcoholic.duckdns.org/oc/index.php/s/jISrPutj4ocLci2/download"
  dir.create("./recomen", showWarnings = F)
  download.file(recoment,destfile="./recomen/tran.csv",mode='wb')
}


## load data to R

library(readr)
chennel<-read_csv("./recomen/chennel.csv")
competitor<-read_csv("./recomen/competitor.csv")
customer<-read_csv("./recomen/customer.csv")
item<-read_csv("./recomen/item.csv")
membership<-read_csv("./recomen/membership.csv")
tran<-read_csv("./recomen/tran.csv")


## head

chennel
competitor
customer
item
membership
tran


## control print row count

options(tibble.print_min = 10)
item


## tail

tail(chennel)
tail(competitor)
tail(customer)
tail(item)
tail(membership)
tail(tran)


## get data summary

summary(chennel)
summary(competitor)
summary(customer)
summary(item)
summary(membership)
summary(tran)


## get data structure

str(chennel)
str(competitor)
str(customer)
str(item)
str(membership)
str(tran)


# 


## set Mysql with google cloud

# user<-"root"
# pw<-"XXXXXXXXXXXXXXXX"
# host<-'XXX.XXX.XXX.XXX'

# save(user,pw,host,file ="./gsql.RData")

load("./gsql.RData")

library(RMySQL)
con <- dbConnect(MySQL(),
                 user = user,
                 password = pw,
                 host = host,
                 dbname = "recom")
dbListTables(conn = con)
dbWriteTable(conn = con, name = 'tran', value = "./recomen/tran.csv")
dbReadTable(conn = con, name = "Test")

## for bigquery query

# select title,sum(num_characters) as num_characters
# from [konlper-168808:test.wikipedia_copy]
# where regexp_match(title,'[Ss]eoul')
# group by title
# order by num_characters desc;

library(bigrquery)
project <- "konlper-168808" 
sql <- "SELECT * FROM [konlper-168808:recom.chennel] LIMIT 5"
query_exec(sql, project = project)