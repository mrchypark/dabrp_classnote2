## DBI

library(DBI)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), dbname="sql_sam.db")

nycflights13::airlines

# check db tables
dbListTables(con)


# write table to db
dbWriteTable(con, "airlines", nycflights13::airlines, overwrite=T)
dbWriteTable(con, "aiports", nycflights13::airports, overwrite=T)
dbWriteTable(con, "flights", nycflights13::flights, overwrite=T)
dbWriteTable(con, "planes", nycflights13::planes, overwrite=T)
dbWriteTable(con, "weather", nycflights13::weather, overwrite=T)

dbListTables(con)

