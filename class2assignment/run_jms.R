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

######과제1 RSQLite와 DBI 활용######################################

#1 'nycflights13'패키지를 설치하고 5개 데이터를 확인
install.packages('nycflights13')

str(nycflights13::airlines)
str(nycflights13::airports)
str(nycflights13::flights)
str(nycflights13::planes)
str(nycflights13::weather)

#2 dbConnect 명령으로 SQLite파일을 sql_jms.db로 생성


con <- dbConnect(RSQLite::SQLite(), dbname="sql_JMS.db")



# check db tables
dbListTables(con)


# write table to db
dbWriteTable(con, "airlines_DBT", nycflights13::airlines, overwrite=T)
dbWriteTable(con, "airports_DBT", nycflights13::airports, overwrite=T)
dbWriteTable(con, "flights_DBT", nycflights13::flights, overwrite=T)
dbWriteTable(con, "planes_DBT", nycflights13::planes, overwrite=T)
dbWriteTable(con, "weather_DBT", nycflights13::weather, overwrite=T)
dbWriteTable(con, "airlines_DBT", nycflights13::airlines, overwrite=T)


dbListTables(con)

