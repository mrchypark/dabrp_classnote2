## DBI

library(DBI)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), dbname="sql_sam.db")

nycflights13::airlines

# check db tables
dbListTables(con)
d


# write table to db
dbWriteTable(con, "airlines", nycflights13::airlines, overwrite=T)
dbWriteTable(con, "aiports", nycflights13::airports, overwrite=T)
dbWriteTable(con, "flights", nycflights13::flights, overwrite=T)
dbWriteTable(con, "planes", nycflights13::planes, overwrite=T)
dbWriteTable(con, "weather", nycflights13::weather, overwrite=T)



library(readr)
customer<-read_csv("./recomen/customer.csv")
item<-read_csv("./recomen/item.csv")
membership<-read_csv("./recomen/membership.csv")

dbWriteTable(con, "channel", "./recomen/chennel.csv", overwrite=T)
dbWriteTable(con, "competitor", "./recomen/competitor.csv", overwrite=T)
dbWriteTable(con, "customer", customer, overwrite=T)
dbWriteTable(con, "item", item, overwrite=T)
dbWriteTable(con, "membership", membership, overwrite=T)




dbListTables(con)

