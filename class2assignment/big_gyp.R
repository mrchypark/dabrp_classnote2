

library(bigrquery)
project <- "precise-victory-156306" 
sql <- "SELECT * FROM [precise-victory-156306:FASTCAMPUS_CLASS.tran] LIMIT 10"
query_exec(sql, project = project)

