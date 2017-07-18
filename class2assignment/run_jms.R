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

######??��1 RSQLite?? DBI Ȱ??######################################

#1 'nycflights13'??Ű???? ??ġ?ϰ? 5?? ?????͸? Ȯ??

install.packages('nycflights13')
library(nycflights13)

ls('package:nycflights13')
data(package = 'nycflights13')

str(nycflights13::airlines)
str(nycflights13::airports)
str(nycflights13::flights)
str(nycflights13::planes)
str(nycflights13::weather)

#2 dbConnect ????��?? SQLite????�� sql_jms.db?? ????


con <- dbConnect(RSQLite::SQLite(), dbname="sql_jms2.db")



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

dbGetQuery(con, 'select * from planes_DBT limit 10')
dbGetQuery(con, 'select * from planes_DBT limit 10')
dbGetQuery(con, 'select year, month,day from flights_DBT limit 10')
dbGetQuery(con, 'select * from flights_DBT where month = 1')
dbGetQuery(con, 'select * from flights_DBT where arr_delay > 120 or dep_delay < 100 and month = 1')



dbGetQuery(con, 'select type, count(*) from planes_DBT group by type')
dbGetQuery(con, 'select type, count(*) as sum from planes_DBT group by type')
dbGetQuery(con, 'select type, count(*) as sum from planes_DBT group by type order by sum')



tem = dbGetQuery(con, 'select * from flights_DBT as a inner join planes_DBT as b on a.tailnum = b.tailnum')

if (!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)

# filter like where
filter(flights, month == 1, day == 1)
jan1 <- filter(flights, month == 1, day == 1)
(dec25 <- filter(flights, month == 12, day == 25))

filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# arrange like order by
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))

# test NA|
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

# select like select
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

rename(flights, tail_num = tailnum)
select(flights, time_hour, air_time, everything())

# ends_with with select
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)
names(flights_sml)
colnames(flights_sml)

# mutate make new columns using calculate others
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
)

mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

# only get new columns
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# extra functions

(x <- 1:10)
lag(x)
lead(x)

# summarise what you want to get
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# group_by 
by_day <- group_by(flights, year, month, day)
class(by_day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))

# ungroup
daily %>% 
  ungroup() %>% 
  summarise(flights = n())

# with pipe
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

# assign values
popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests


popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

# tidyr examples
table1
table2
table3
table4a
table4b

# case of column name is value
table4a
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")

# case of value is column name
table2
spread(table2, key = type, value = count)

# separate columns
table3
table3 %>% 
  separate(rate, into = c("cases", "population"))

# separate columns with class set
table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)

# separate int columns
table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)
table5 = table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)


# unite two columns to new column
table5 %>% 
  unite(new, century, year)

# unite two columns to new column controll to sep characters
table5 %>% 
  unite(new, century, year, sep = "")


# join example

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2

# left join with dplyr
flights2 %>%
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")

# left join with dplyr without join function
flights2 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# join without key
flights2 %>% 
  left_join(weather)


flights2 %>% 
  left_join(planes, by = "tailnum")

flights2 %>% 
  left_join(planes)

# join with diff key names

flights2 %>% 
  left_join(airports, c("dest" = "faa"))

flights2 %>% 
  left_join(airports, c("origin" = "faa"))


## dplyr with db
library(dplyr)
library(RSQLite)

sqlite_db = src_sqlite('sqlite_db.sqlite', create = T)
copy_to(sqlite_db, mtcars)

src_tbls(sqlite_db)
tbl(sqlite_db, 'mtcars')
tbl(sqlite_db, sql('SELECT * FROM mtcars'))

iris_db = tbl(sqlite_db, 'mtcars')
iris_db %>% filter(mpg > 20)

sql_db = src_mysql(dbname="bank",user = "root",password = "XXXX")
sql_db

src_bigquery


# data.table

library(data.table)

# get data

# url<-"https://github.com/arunsrinivasan/flights/wiki/NYCflights14/flights14.csv"
# dir.create("./data",showWarnings = F)
# download.file(url,destfile = "./data/flights14.csv")

# read data
system.time(flights <- read.csv("./data/flights14.csv"))
system.time(flights <- read_csv("./data/flights14.csv"))
system.time(flights <- fread("./data/flights14.csv"))
flights
class(flights)
dim(flights)

# subset like where
ans <- flights[origin == "JFK" & month == 6L]
head(ans)

ans <- flights[1:2]
ans

# order like order by
ans <- flights[order(origin, -dest)]
head(ans)

# select column like select
ans <- flights[, arr_delay]
head(ans)

# select columns like select
ans <- flights[, .(arr_delay, dep_delay)]
head(ans)

# rename
ans <- flights[, .(delay_arr = arr_delay, delay_dep = dep_delay)]
head(ans)

# transmute
flights[origin == "JFK" & month == 6L,
        .(m_arr = mean(arr_delay), m_dep = mean(dep_delay))]

# length
flights[origin == "JFK" & month == 6L, length(dest)]

# make count table 
flights[, .(.N), by = .(origin)]

# make count table with condition
flights[carrier == "AA", .N, by = origin]

# make count table with condition and group by
flights[carrier == "AA", .N, by = .(origin,dest)]

# add options
flights[carrier == "AA", .N, by = .(origin, dest)][order(origin, -dest)][1:10,]


