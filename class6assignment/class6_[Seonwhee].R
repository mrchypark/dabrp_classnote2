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
library(ggmap)

Geo_wifi <- function(DATA, NAME, loc, SCALE){
  wifi_district <- data.frame()
  labels = unique(NAME)
  for(label in labels){
    ct <- count(DATA, vars=sprintf("%s", label))
    geo <-geocode(sprintf("%s", label), output = "latlon")
    ct <- cbind(ct, geo)
    wifi_district = rbind(wifi_district, ct)
  }
  get_googlemap(loc, scale = SCALE, maptype = "roadmap") %>% 
    ggmap() + geom_point(data=wifi_district, aes(x=lon, y=lat, color=vars, size=n))
}

con <- dbConnect(RSQLite::SQLite(), dbname="./wifi_data.sqlite")
dbWriteTable(con, "wifi_Seoul", Seoul_wifi, overwrite=T)

#서울중 각 구에 wifi가 몇개 잇는지 세고 각 구 이름으로 geocoding한 위치에 갯수를 size로 하는 버블 차트를 그려주세요.
#시도를 기준으로 위와 같은 버블 차트를 그려주세요.
Geo_wifi(Seoul_wifi, Seoul_wifi$설치시군구명, "서울", 2)
Geo_wifi(wifi, wifi$설치시도명, "대한민국", 1)


#시도를 기준으로 wifi의 수가 기간에 따라 얼마나 늘어났는지 확인할 수 있는 라인 차트를 그려주세요.
unique(wifi$설치년월)

#서비스제공사명을 기준으로 통신 3사가 아닌 제공사는 기타로 처리하고, 여러 개로 작성된 것은 각 개수 만큼 분리하여 독립 wifi로 처리하여 위의 차트를 서비스제공사명으로 그룹지어서 그려주세요. 총 4개 차트가 함께 나오면 됩니다.
