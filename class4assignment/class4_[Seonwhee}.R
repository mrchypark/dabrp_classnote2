## Problem 1 ####
if (!require(data.table)) install.packages("data.table")
ITEM <-fread("./recomen/item.csv")
head(ITEM)
LIP = grep("*립$", ITEM$cate_3_name)
Answer1_Lib = ITEM[LIP,]

Sauce = grep("*(소스)$", ITEM$cate_3_name)
Answer1_Sauce = ITEM[Sauce,]


Answer1 = Answer1_total$partner
Answer1
##################

