if (!require(tidyverse)) install.packages("tidyverse") 
if (!require(data.table)) install.packages("data.table") 
if (!require(gapminder)) install.packages("gapminder") 
library(tidyverse)
library(data.table)
library(arules)
library(gapminder)
str(gapminder)
p <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp))
p
head(gapminder)
gap_af <- filter(gapminder, country == "Afghanistan")
gap_af <- gapminder[gapminder$country=="Afghanistan",]
class(gap_af)
p_af <- ggplot(as.data.frame(gap_af), aes(x= year, y=lifeExp))
p_af + geom_line()
######################################################################
ggplot(gapminder) + geom_point(aes(x = log10(gdpPercap),y = lifeExp))
p_point <- p + geom_point()
p_point_log10 <- p_point + scale_x_log10()
p_point_color <- p + geom_point(aes(color = continent))
summary(p_point_color)
summary(p + geom_point(alpha = (1/3), size = 3 ))
summary(p + geom_point(aes(alpha = (1/3), size = 3) ))
p + geom_point(alpha = (1/3), size = 3)
p_point + stat_smooth()
p_point + geom_smooth(lwd = 2, se = FALSE, method = "lm")
p_point_color + geom_smooth(lwd = 2, se = FALSE)
p + aes(color = continent) + geom_point() + geom_smooth(lwd = 1, se = FALSE)
p + aes(color = continent) + geom_point() + geom_smooth(lwd = 2, se = FALSE)
p + aes(group = continent) + geom_point() + geom_smooth(lwd = 2, se = FALSE)
(lp <- ggplot(gapminder) + geom_jitter(aes(x = year, y = lifeExp )))
lp + facet_wrap(~continent)
######################################################################
p1 <- ggplot(gapminder)
p1 + geom_histogram(aes(x=pop))
p2 <- ggplot(gapminder)
#p2 + geom_violin(aes(x=continent, y=lifeExp)) + stat_function(aes(y=lifeExp, color=continent), fun = mean)

p2 + geom_violin(aes(x=continent, y=lifeExp)) + stat_summary(color="blue")
p2 + geom_violin(aes(x=continent, y=lifeExp)) + geom_point(gapminder[,.N,by=(continent)], aes(x=continent, y=N))
p2 + geom_violin(aes(x=continent, y=lifeExp)) + geom_point(gapminder %>% group_by(continent) %>% summarise(n()), aes(x=continent, y=N))

jCountries <- c("Canada", "Rwanda", "Cambodia", "Mexico")
gapminder %>% filter(country == "Cambodia")
p4 <- gapminder %>% filter(country %in% jCountries) %>%
  ggplot(aes(x=year, y=lifeExp)) + geom_line()+ geom_point()
p4

p4 <- gapminder %>% filter(country %in% jCountries) %>%
  ggplot(aes(x=year, y=lifeExp, color = country)) + geom_line()+ geom_point()
p4
################################################################################

dir.create("../ggsave", showWarnings = F)
for(i in 1:length(unique(gapminder$country))){
  gapminder %>% filter(country == gapminder$country[i]) %>%
    ggplot(aes(x = year, y = lifeExp, color = country)) +
    geom_line() + geom_point() +
    ggsave(paste0("./ggsave/",gapminder$country[i],".png"))
  # print(paste0(i," / ",length(unique(gapminder$country))))
}
###############################################################################

if (!require("ggmap"))
{devtools::install_github("dkahle/ggmap")}
library(ggmap)
# for mac
loc<-"서울"
tar<-"서울시청"
# for windows
loc<-URLencode(enc2utf8("서울"))
tar<-URLencode(enc2utf8("서울시청"))
geocityhall<-geocode(tar)
get_googlemap(loc,maptype = "roadmap", markers = geocityhall) %>% 
  ggmap()

wifi <- fread("./data/wifi.csv")
head(wifi)

get_googlemap(loc,
              maptype = "roadmap", 
              markers = geocityhall) %>% ggmap()

get_googlemap(center=loc, zoom = 11) %>% ggmap()

get_googlemap(loc, maptype = "roadmap") %>% 
  ggmap() + 
  geom_point(data, aes(x=lon, y=lat))

