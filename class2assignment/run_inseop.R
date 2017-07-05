install.packages("nycflights13")
nycflights13::airlines
nycflights13::airports
nycflights13::flights
nycflights13::planes  
nycflights13::weather  

if (!require(devtools)) install.packages("devtools") 
if (!require(DBI)) devtools::install_github("rstats-db/DBI")
if (!require(RSQLite)) devtools::install_github("rstats-db/RSQLite")
if (!require(RMySQL)) devtools::install_github("rstats-db/RMySQL")
if (!require(bigrquery)) devtools::install_github("rstats-db/bigrquery")
if (!require(data.table)) install.packages("data.table")
if (!require(readr)) install.packages("readr")

library(DBI)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), dbname="sql_inseop.db")

dbListTables(con)

dbWriteTable(con, "airlines", nycflights13::airlines , overwrite=T)
dbWriteTable(con, "airports", nycflights13::airports , overwrite=T)
dbWriteTable(con, "flights", nycflights13::flights , overwrite=T)
dbWriteTable(con, "planes", nycflights13::planes , overwrite=T)
dbWriteTable(con, "weather", nycflights13::weather , overwrite=T)
dbListTables(con)
