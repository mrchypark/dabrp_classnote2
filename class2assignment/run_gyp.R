
#homework1

#1.1 : install 'nycflights13' packages and check 5 rows of data

install.packages("nycflights13")

head(nycflights13::airlines)
nycflights13::


#1.2

if (!require(devtools)) install.packages("devtools") 
if (!require(DBI)) devtools::install_github("rstats-db/DBI")
if (!require(RSQLite)) devtools::install_github("rstats-db/RSQLite")

library(DBI) 
library(RSQLite)
con <- dbConnect(SQLite(), dbname="sql_gyp.db") 

# check db tables
dbListTables(con)


# write table to db
dbWriteTable(con, "airlines", nycflights13::airlines, overwrite=T)
dbWriteTable(con, "airports", nycflights13::airports, overwrite=T)
dbWriteTable(con, "flights", nycflights13::flights, overwrite=T)
dbWriteTable(con, "planes", nycflights13::planes, overwrite=T)
dbWriteTable(con, "weather", nycflights13::weather, overwrite=T)


dbListTables(con)


