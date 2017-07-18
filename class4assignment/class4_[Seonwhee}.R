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

