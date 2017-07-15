## Problem 1 ####
if (!require(data.table)) install.packages("data.table")
ITEM <-fread("./recomen/item.csv")
head(ITEM)
LIP = grep("*립$", ITEM$cate_3_name)
Answer1_Lip = ITEM[LIP,]

Sauce = grep("*(소스)$", ITEM$cate_3_name)
Answer1_Sauce = ITEM[Sauce,]

Slash = grep("*//*", ITEM$cate_3_name)
Products = ITEM$cate_3_name[Slash]
Products_list = strsplit(Products, "/")
Products_vector = unlist(Products_list)
Answer1_Slash = unique(Products_vector)

Answer1_1 = Answer1_Lip$partner
Answer1_2 = Answer1_Sauce$cate_3_name
Answer1_3 = length(Answer1_Slash)

##################
## Problem 2 ###################
Test_ref <- c("김민수", "김갑수", "김병수", "김진수","김홍수", "김자수", "김지수", "김흥수", "김찬수", "김경수", "김해수", "김가수", "김고수")
ref2 <- c("김응용", "김성근", "김인식", "김경문", "김한수", "김혜수")
grep("^김(경|찬|갑)수?", Test_ref)
grep("^김(경|찬|갑)수?", ref2)


