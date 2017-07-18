item<-fread("./recomen/item.csv", encoding = "UTF-8")
elevator<-fread("./data/elevatorkr16.csv", encoding = "UTF-8")
getwd()

str(item)

#1.1 recomen의 item.csv파일에서 cate_3_name이 립으로 시작하는 제품을 판매하는 파트너사



Problem1_1 <- item %>%  filter(grepl("^립", cate_3_name))  %>% 
  select(partner) %>% 
  unique()

Problem1_1 # B, C, D


#1.2 cate_3_name이 "소스"으로 시작하는 제품

Problem1_2 <- item %>%  filter(grepl("^립", cate_3_name)) %>% 
  select(cate_3_name) %>% 
  unique()

Problem1_2 # 소스, 수입소스, 양념소스, 국물용소스, 파스타소스

#1.3 '/'로 합쳐져 있는 cate_3_name를 모두 잘라서 유일한 제품명만 세면 모두 몇개인가요?

Problem1_2.1 <- item %>%  separate(cate_3_name, into = c("first", "second"), sep = '/') %>%
  select(first, second)

a <- Problem1_2.1[!is.na(first),"first"]
b <- Problem1_2.1[!is.na(second),"second"] %>%
  rename(first = second)

Problem1_2.2 <- rbind(a, b) %>% select(first) %>%
  unique() %>% nrow()


Problem1_2.2 # 3636



#2.1 대한민국에 등록된 승강기 목록으로 (주)가 포함되고 빌딩으로 끝나는 건물명을 가진 건물수

str(elevator)

Problem1_2.1 <- elevator %>%  
  filter(grepl("\\(\\주\\)", 건물명))

Problem1_2.1 <- Problem1_3.1 %>% 
  filter(grepl("빌딩$", 건물명)) %>% 
  nrow()

Problem1_2.1.2 <- elevator %>%
  filter(grepl("\\(주\\).*빌딩$", 건물명)) %>% 
  nrow()

Problem1_2.1 ; Problem1_2.1.2 #329


#2.2 지역이름중 2글자+시로 이루어진 지역이 속한 도의 리스트

summary(as.factor(elevator$지역))

Problem1_2.3 <- elevator %>%  
  filter(grepl(" ..시", 지역))  %>% 
  separate(지역, into = c('SIDO',"SGG1","SGG2"), sep = " ")  %>%
  select(SIDO)  %>%
  unique()

Problem1_2.3 # 강원, 경기, 경남, 경북, 전남, 전북, 제주, 충남, 충북


#2.3 승강기 종류중 마지막 글자가 "용"이 아닌 것의 리스트

summary(as.factor(elevator$승강기종류))

Problem1_3.2 <- elevator %>%  
  filter(!grepl("용$", 승강기종류))  %>% 
  select(승강기종류)  %>%
  unique()

Problem1_3.2 # 덤웨이터, 화물용(DW), 수직형휠체어리프트,
# 수평보행기, 경사형휠체어리프트, 비상/장애/승객화물, 에스컬레이터, 소형엘리베이터




#과제3 아래조건에 해당하는 정규표현식 패턴을 작성해주세요

#3.1 국내휴대전화번호

grepl("^\\(?[0-9]{2,3}\\)?[-. ]?[0-9]{3,4}[-. ]?[0-9]{4}$","02-546-7122")

tel_number <- c('02-546-7122','010-8782-7122','02-471-0309',
                '02-6447-7799', '017-273-4616','1588-0100', 
                '02.546.7122', '010.8782.7122','010 9271 1199',
                '01092711199','(010)8782-7122')

grepl("^\\(?0[0-9]{2}\\)?[-. ]?[0-9]{3,4}[-. ]?[0-9]{4}$",tel_number)


#3.2 <!-- 주석내용-->

grepl('^<!--.*-->',  '<!-- 주석내용-->')



#3.3 IPv4

grepl('^[[:upper:]][[:upper:]][[:lower:]][[:digit:]]$', 'IPv4')



#과제4 dabrp_class2 프로젝트를 연 후에 dir 함수를 이용하여 아래질문에 답하라


#4.1 class2assignment 폴더의 db확장자 파일의 개수


dir(path = ".", pattern = NULL, all.files = FALSE,
    full.names = FALSE, recursive = FALSE,
    ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)


dir(path = "./class2assignment", pattern = ".*\\.R") 
   

#4.2 working diractory에서 R확장자 파일 리스트

dir(path = ".", pattern = ".*\\.R") 


#4.3 모든곳에서 R확장자 파일의 리스트(recursive 인자 참조)

dir(path = ".", pattern = ".*\\.R", recursive = TRUE) 

  
