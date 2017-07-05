library(bigrquery)
project <- "teak-listener-172112"
sql <- "SELECT * FROM [teak-listener-172112:recom.tran] LIMIT 10"
query_exec(sql, project = project)
'''