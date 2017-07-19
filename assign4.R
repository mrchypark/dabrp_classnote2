if (!require(tidyverse)) install.packages("tidyverse") 
if (!require(data.table)) install.packages("data.table") 
library(tidyverse)
library(data.table)

## 과제 1 데이터 준비

item<-fread("./recomen/item.csv", encoding = "UTF-8")

## 과제 1.1

item %>% 
  filter(grepl("^립",cate_3_name)) %>% 
  select(partner) %>% 
  unique

item[grep("^립",cate_3_name),partner] %>% unique

## 과제 1.2

item %>% 
  filter(grepl("소스$",cate_3_name)) %>% 
  select(cate_3_name) %>% 
  unique

item[grep("소스$",cate_3_name),cate_3_name] %>% unique

## 과제 1.3

st1 <- strsplit(item$cate_3_name,"/") %>%
  unlist %>%
  unique %>%
  .[order(.)]

st1 %>%
  length

tem <- item %>%
  separate(cate_3_name, into=c("v1","v2"), sep="/")

st2<-c(tem$v1, tem$v2) %>% unique %>% .[order(.)]
st2 %>% length

st1[!(st1 %in% st2)]

st2[!(st2 %in% st1)]

item[grep("(/.*?){2,}",cate_3_name),]

## 과제 2 데이터 준비

elev<-fread("./data/elevatorkr16.csv", encoding = "UTF-8")
elev

## 과제 2.1

elev %>% 
  filter(grepl("\\(주\\).*빌딩",`건물명`)) %>%
  group_by(`지역`,`건물명`,`건물용도(대)`) %>%
  summarise(n()) %>%
  nrow
  
elev[grepl("\\(주\\).*빌딩",`건물명`)][,.N,by=.(`지역`,`건물명`,`건물용도(대)`)] %>% nrow

## 과제 2.2

elev %>%
  filter(grepl(" .{2}시",`지역`)) %>%
  select(`지역`) %>%
  unique %>%
  separate(`지역`, into=c("tar","rest"),sep=" ") %>%
  select(tar) %>%
  unique

tem<-elev[grep(" .{2}시",`지역`),`지역`]
lapply(strsplit(tem, " "), function(x) x[1]) %>%
  unlist %>% unique

## 과제 2.3

elev %>%
  filter(!grepl("용$",`승강기종류`)) %>%
  select(`승강기종류`) %>%
  unique

elev[!grepl("용$",`승강기종류`),`승강기종류`] %>% unique

## 과제 다음장 1 샘플 데이터 준비

# 휴대폰 번호 생성 함수 작성
genNum <- function(){
  result <- paste0(sample(0:9,1,prob=c(0.5,replicate(9,0.5/9))),"1",sample(0:9,1),"-",
                   sample(2:9,1), paste0(sample(0:9,sample(2:3,1),replace = T),collapse=""),"-",
                   paste0(sample(0:9,4,replace = T),collapse=""))
  return(result)
}

# 랜덤의 고정
set.seed(1234)
# 10,000번 시행
dat1 <- replicate(10000,genNum())

# http/1.1의 요청을 처리해주는 패키지
if (!require(httr)) install.packages("httr") 
library(httr)

# onoffmix 메인 페이지의 html 문서 가져오기
dat2 <- GET("https://onoffmix.com/") %>%
  content("parsed") %>%
  as.character %>%
  strsplit(">") %>%
  .[[1]] %>%
  paste0(">") %>%
  str_trim

# ip 생성 함수 작성
genIpv4 <- function(){
  result <- paste0(paste0(sample(0:9,sample(1:3,1),replace = T),collapse=""), ".",
                   paste0(sample(0:9,sample(1:3,1),replace = T),collapse=""), ".",
                   paste0(sample(0:9,sample(1:3,1),replace = T),collapse=""), ".",
                   paste0(sample(0:9,sample(1:3,1),replace = T),collapse=""))
  return(result)
}

# 랜덤의 고정
set.seed(1234)
# 10,000번 시행
dat3 <- replicate(10000,genIpv4())

## 과제 다음장 1.1
# 국내 휴대전화 규칙
# https://ko.wikipedia.org/wiki/%EB%8C%80%ED%95%9C%EB%AF%BC%EA%B5%AD%EC%9D%98_%EC%A0%84%ED%99%94%EB%B2%88%ED%98%B8_%EC%B2%B4%EA%B3%84#.EC.9D.B4.EB.8F.99.ED.86.B5.EC.8B.A0_.EB.B0.8F_.EB.B6.80.EA.B0.80.ED.86.B5.EC.8B.A0.EB.A7.9D_.EB.93.B1_.2801X.29

dat1[grep("^01[16789]-[0-9]{3,4}-[0-9]{4}$",dat1)]

## 과제 다음장 1.2
# html 주석
library(stringr)
dat2[grep("<!--.*?-->",dat2)]

dat2 <- GET("https://onoffmix.com/") %>%
  content("parsed") %>%
  as.character
str_extract_all(dat2,"<!--.*?-->")[[1]]
dat2[grep("대표",dat2)]

## 과제 다음장 1.3

dat3[grep("^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$",dat3)]

## 과제 다음장 2 데이터 준비

# 없음

## 과제 다음장 2.1

dir("./class2assignment/", pattern = "\\.db$") %>% length

## 과제 다음장 2.2

dir(pattern = "\\.R$")

## 과제 다음장 2.3

dir(pattern = "\\.R$", recursive = T)




