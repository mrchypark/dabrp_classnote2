library(rpudplus)
data(iris)
train<-iris[,-5]
train
str(iris)

class(train)
k = 3
m = 10
km <- kmeans(train, centers = k, iter.max = m)
summary(km)
km
train2 <- scale(train, center=T, scale=T)
km2 <- kmeans(train2, centers = k, iter.max = m)
km2
summary(km2)
table(iris[,5], km$cluster)
table(iris[,5], km2$cluster)


library(MASS)
data(birthwt)
str(birthwt)
birthwt <- birthwt[-1]
factor(birthwt$race)
typeof(birthwt$race)
str(birthwt$race)
fit <- lm(bwt ~ age + lwt + race + factor(smoke) + ptl + factor(ht) + factor(ui) + ftv, data=birthwt)
summary(fit)


set.seed(1234)
tar   <- sample(1:nrow(birthwt),round(nrow(birthwt)*0.7))
train <- birthwt[tar, ]
test  <- birthwt[-tar, ]
fit<-lm(bwt ~ age + lwt + race + factor(smoke) + ptl + factor(ht) + factor(ui) + ftv, data=train)

nrow(train)
nrow(test)
predict(fit, test) 
test[,"bwt"]
sum(abs(predict(fit, test)-test[,"bwt"]))
library(arules)
data("Groceries")
summary(Groceries)
inspect(Groceries[1:10,])
dvdread<-read.csv("./data/dvdtrans.csv")
head(dvdread)
dvdtran<-read.transactions("./data/dvdtrans.csv")
inspect(dvdtran[1:10,])
class(dvdtran)
class(dvdread)
head(dvdread)
factor(dvdread$ID)

x <- 1
paste0("hello ", x)
paste0(letters, collapse = "_")

newDVD <- split(dvdread, paste(dvdread$ID))
unlist(newDVD)


#########################################
as(split(dvdread$ID, dvdread$Item), "transactions")

dvdread %>%
  group_by(ID) %>%
  summarise(text=paste0(Item, collapse=', '))

dvdread <- data.table::data.table(dvdread)
#dvdread[,[paste(Item, collapse = ", ")]
rule <- apriori(data = Groceries, 
                parameter = list(support = 0.01, 
                                 confidence = 0.2, 
                                 minlen = 2))
