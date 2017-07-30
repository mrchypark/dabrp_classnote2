library(tidyverse)
library(data.table)
library(arules)

chennel <-fread("./recomen/chennel.csv")
head(chennel)
p1 <- ggplot(chennel, aes(x=chennel, y=useCnt))
p1 <- p1 + geom_bar(stat = "identity") + stat_sum()
p1
p2 <- ggplot(chennel, aes(x=chennel, y=useCnt))
p2 <- p2 + geom_bar(stat = "identity")
p2

competitor <- fread("./recomen/competitor.csv")
head(competitor)


p3 <- ggplot(competitor[, .N, by=(useDate)], aes(x=useDate, y=N))
p3 <- p3 + geom_line()
p3
unique(competitor$partner)
p4 <- ggplot()
p4 <- p4 + geom_line(data=competitor[partner=="A", .N, by=(useDate)], aes(x=useDate, y=N, colour="blue"))
p4 <- p4 + geom_line(data=competitor[partner=="B", .N, by=(useDate)], aes(x=useDate, y=N, colour="red"))
p4 <- p4 + geom_line(data=competitor[partner=="C", .N, by=(useDate)], aes(x=useDate, y=N, colour="yellow"))
p4 <- p4 + geom_line(data=competitor[partner=="D", .N, by=(useDate)], aes(x=useDate, y=N, colour="black"))
p4
