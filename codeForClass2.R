if (!require(devtools)) install.packages("devtools") 
if (!require(DBI)) devtools::install_github("rstats-db/DBI")
if (!require(RSQLite)) devtools::install_github("rstats-db/RSQLite")
if (!require(RMySQL)) devtools::install_github("rstats-db/RMySQL")



# user<-"root"
# pw<-"XXXXXXXXXXXXXXXX"
# host<-'XXX.XXX.XXX.XXX'

# save(user,pw,host,file ="./gsql.RData")

load("./gsql.RData")

library(RMySQL)
con <- dbConnect(MySQL(),
                 user = user,
                 password = pw,
                 host = host,
                 dbname = "test")
dbListTables(conn = con)
dbWriteTable(conn = con, name = 'Test', value = as.data.frame(iris))
dbReadTable(conn = con, name = "Test")

chk<-file.info("./recomen/tran.csv")
if(is.na(chk$size)){
  recoment<-"http://rcoholic.duckdns.org/oc/index.php/s/jISrPutj4ocLci2/download"
  dir.create("./recomen", showWarnings = F)
  download.file(recoment,destfile="./recomen/tran.csv",mode='wb')
}
