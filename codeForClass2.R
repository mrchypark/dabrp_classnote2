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