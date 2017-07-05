# set packages

if (!require(devtools)) install.packages("devtools") 
if (!require(DBI)) devtools::install_github("rstats-db/DBI")
if (!require(RSQLite)) devtools::install_github("rstats-db/RSQLite")
if (!require(RMySQL)) devtools::install_github("rstats-db/RMySQL")
if (!require(bigrquery)) devtools::install_github("rstats-db/bigrquery")
if (!require(data.table)) install.packages("data.table")
if (!require(readr)) install.packages("readr")
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(nycflights13)) install.packages("nycflights13")


# db set
library(DBI)
library(RSQLite)
library(nycflights13)
con <- dbConnect(RSQLite::SQLite(),
                 dbname="class3.sqlite")

# write tables
dbWriteTable(con, "flights", flights, overwrite=T)
dbWriteTable(con, "airlines", airlines, overwrite=T)
dbWriteTable(con, "airports", airports, overwrite=T)
dbWriteTable(con, "planes", planes, overwrite=T)
dbWriteTable(con, "weather", weather, overwrite=T)

# check table list
dbListTables(con)

# select from 
dbGetQuery(con, "select * from planes limit 10")

# select from where
dbGetQuery(con, "select * from planes where year > 2000 limit 10")

# select columns
dbGetQuery(con, "select year, month, day from flights limit 10")

# group by
dbGetQuery(con, "select type, count(*) from planes group by type")

# order by 
dbGetQuery(con, "select type, count(*) from planes group by type order by count(*)")
dbGetQuery(con, "select type, count(*) as sum from planes group by type order by count(*)")
# count의 이름을 sum으로 변경->as

# where
dbGetQuery(con, "select * from flights where month = 1")

# and
dbGetQuery(con, "select * from flights where month = 12 and day = 25")

# or
dbGetQuery(con, "select * from flights where arr_delay > 120 or dep_delay > 120")
#and와 or는 동일하게 사용

# inner join
dbGetQuery(con, "select * from flights as a inner join planes as b on a.tailnum = b.tailnum")
dbGetQuery(con, "select * from flights as a inner join planes as b on a.tailnum = b.tailnum")->tem
dim(tem)
dim(flights)
dim(planes)
#a에만 있고, 


library(tidyverse)

# data
flights

# filter like where
filter(flights, month == 1, day == 1)  #filter 명령어는 쉼표로 여러개의 and조건을 처리할 수 있음

jan1 <- filter(flights, month == 1, day == 1)
(dec25 <- filter(flights, month == 12, day == 25))
dec25 %>% summary
#12월 25일만 뽑아서 dec25에 저장하고, summary로 잘 뽑아냈는지 확ㅇ

filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))인
# %in% sms 뒤에 오는 기간내의 모든 row를 뽑는다는 의미
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)
#위 두 명령어는 같은 결과가 나온다. !를 통해서 반대의 데이터 추출한다.

# arrange like order by
# arrange 원하는 조건을 순서대로 나열, 아래의 명령어는 year로 1차, month로 2차, day로 마지막 정렬을 한다.
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))함 #desc는 거꾸로 배ㅇ

# test NA|
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))
#arrange는 항상 NA를 가장 마지막으로 배열한다.

# select like select
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))
# -로 해당 row를 제외한 나머지 row 선택


rename(flights, tail_num = tailnum) #column 이름 변경, 앞에가 변경할 이르
select(flights, time_hour, air_time, everything())
#everything 앞에 column을 지정했고, 그 뒤에 everything을 써도 중복으로 column이 작성되지 않음


# ends_with with select
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

# mutate make new columns using calculate others열
# 있는 column으로 계산하여 column을 추가하는 명령어
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
# 새로 정의한 column만 나오고, 기존의 column은 사라짐.
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# extra functions

(x <- 1:10)
lag(x) # 하나 뒤로 미룸(맨 앞 없애기) 
lead(x) # 하나 앞으로 당김(맨 끝 없애기)

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

# ungroup : 그룹해제
daily %>% 
  ungroup() %>% 
  summarise(flights = n())
# n(()) 개수를 세는 명령어

summarise(group_by(flights,year,month,day)
          delay = mean(dep_delay, na.rm = TRUE))
flights %>%
  group_by(year,month,day) %?%
  summarise(delay=mean(dep_delay, na.rm = TRUE))
#위 두 명령어는 같은 명령어. pipe를 사용한 것 뿐이다.



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

# tidyr examples : 패키지에 내장시켜놓음. 
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
#key는 어떤 column을 펼칠 것인지, value는 어떤 값을 펼쳐서 나타낼건지 지정


# separate columns
table3
table3 %>% 
  separate(rate, into = c("cases", "population"))

# separate columns with class set
table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)
# chr로 된 column의 형태를 int로 변환해주는게 convert


# separate int columns : 2글자로 쪼개기
table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

# unite two columns to new column: 합치면 중간 인자가 기본적으로 _ (under bar)가 들어감.
table5 %>% 
  unite(new, century, year)

# unite two columns to new column controll to sep characters
table5 %>% 
  unite(new, century, year, sep = "")
# sep로 중간 인자 지정



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
# 속도가 더 빨라서, 대용량 데이터 불러올때 용이함.
library(data.table)
#data table cheat sheet -> data.table using method explain.

# get data

# url<-"https://github.com/arunsrinivasan/flights/wiki/NYCflights14/flights14.csv"
# dir.create("./data",showWarnings = F)
# download.file(url,destfile = "./data/flights14.csv")

# read data
system.time(flights <- read.csv("./data/flights14.csv"))
system.time(flights <- read_csv("./data/flights14.csv"))
system.time(flights <- fread("./data/flights14.csv"))
flights
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
# column을 불러올 때, C를 사용하지 않고, 점(.)만 찍고 row name도 ""를 하지 않음
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
# origin으로 묶어서 (.N)을 쓰면 개수를 세는 것. / .sd는 표준편차를 구함

# make count table with condition
flights[carrier == "AA", .N, by = origin]

# make count table with condition and group by
flights[carrier == "AA", .N, by = .(origin,dest)]

# add options
flights[carrier == "AA", .N, by = .(origin, dest)][order(origin, -dest)][1:10,]
# pipe로 데이터 연산을 연속하는 것처럼, data.table은 []를 이용해서 연산자를 연결함.



