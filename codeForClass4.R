if (!require(tidyverse)) install.packages("tidyverse") 
library(stringr)


# length
str_length("abc")
str_length("한글")

# subset
x <- c("abcdef", "ghifjk")
str_sub(x, 3, 3)
str_sub(x, 2, -2)

# replace subset
str_sub(x, 3, 3) <- "X"
x

# duplicate
str_dup(x, c(2, 3))


# padding
x <- c("abc", "defghi")
str_pad(x, 10)
str_pad(x, 10, "both")

str_pad(x, 4)

# truncate text
x <- c("Short", "This is a long string")
x %>% 
  str_trunc(10) %>% 
  str_pad(10, "right")

# remove blank
x <- c("  a   ", "b   ",  "   c")
str_trim(x)
str_trim(x, "left")

# locale sensitive function
x <- "I like horses."
str_to_upper(x)
str_to_title(x)
str_to_lower(x)

# ordering
x <- c("y", "i", "k")
str_order(x)
str_sort(x)

# set sample data
strings <- c(
  "apple", 
  "219 733 8965", 
  "329-293-8753", 
  "Work: 579-499-7527; Home: 543.355.3679"
)
phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"

# match functions
str_subset(strings, phone)
str_detect(strings, phone)
str_count(strings, phone)

# which locate
str_locate(strings, phone)
str_locate_all(strings, phone)

# extract matching text
str_extract(strings, phone)
str_extract_all(strings, phone)
str_extract_all(strings, phone, simplify = TRUE)

# return match and matching group
str_match(strings, phone)
str_match_all(strings, phone)

# replace
str_replace(strings, phone, "XXX-XXX-XXXX")
str_replace_all(strings, phone, "XXX-XXX-XXXX")

# split strings
str_split("a-b-c", "-")
str_split_fixed("a-b-c", "-", n = 2)

