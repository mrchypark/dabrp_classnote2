library(bigrquery)
project <- "dabrp-classnote2" 
sql <- "SELECT * FROM [dabrp-classnote2:recom.tran] LIMIT 10"
query_exec(sql, project = project)