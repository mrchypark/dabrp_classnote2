if(!require(rmarkdown)) install.packages("rmarkdown")
library(rmarkdown,lib.loc = "C:/Users/mrchypark/Documents/R/win-library/3.4")

Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc")

render(input = "C:/Users/mrchypark/Documents/project/dabrp_classnote2/class7sample/pdftesthangul.Rmd",
       encoding="UTF-8")
