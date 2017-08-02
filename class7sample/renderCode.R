if(!require(rmarkdown)) install.packages("rmarkdown")
library(rmarkdown,lib.loc = "C:/Users/mrchypark/Documents/R/win-library/3.4")

render(input = "C:/Users/mrchypark/Documents/project/dabrp_classnote/class7sample/pdftesthangul.Rmd",
       encoding="UTF-8")
