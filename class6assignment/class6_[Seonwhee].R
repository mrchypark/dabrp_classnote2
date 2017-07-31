library(tidyverse)
library(data.table)
library(arules)

############ Problem 1 ############################
chennel <-fread("./recomen/chennel.csv")
head(chennel)
p1 <- ggplot(chennel, aes(x=chennel, y=useCnt))
p1 <- p1 + geom_bar(stat = "identity")
p1

competitor <- fread("./recomen/competitor.csv")
head(competitor)

p3 <- ggplot(competitor[, .N, by=(useDate)], aes(x=useDate, y=N))
p3 <- p3 + geom_line()
p3
unique(competitor$partner)
p4 <- ggplot()
p4 <- p4 + geom_line(data=competitor[partner=="A", .N, by=(useDate)], aes(x=useDate, y=N, colour="B"))
p4 <- p4 + geom_line(data=competitor[partner=="B", .N, by=(useDate)], aes(x=useDate, y=N, colour="R"))
p4 <- p4 + geom_line(data=competitor[partner=="C", .N, by=(useDate)], aes(x=useDate, y=N, colour="Y"))
p4 <- p4 + geom_line(data=competitor[partner=="D", .N, by=(useDate)], aes(x=useDate, y=N, colour="K"))
p4

########### Problem 3 ################################
wifi <- fread("./data/wifi.csv")
head(wifi)
Seoul = grep("(서울)+", wifi$소재지도로명주소)
Seoul_wifi <- wifi[Seoul,]
library(DBI)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), dbname="./wifi_data.sqlite")
dbWriteTable(con, "wifi_Seoul", Seoul_wifi, overwrite=T)
head(Seoul_wifi)
District <- unique(Seoul_wifi$설치시군구명)

Seoul_wifi_district = data.frame()
for(Gu in District){
  cc <- count(Seoul_wifi, vars=sprintf("%s", Gu))
  Seoul_wifi_district = rbind(Seoul_wifi_district, cc)
}
print(Seoul_wifi_district)

Cities <- unique(wifi$설치시도명)
Cities
City_wifi <- data.frame()
for(city in Cities){
  cc <- count(wifi, vars=sprintf("%s", city))
  City_wifi = rbind(City_wifi, cc)
}
print(City_wifi)
