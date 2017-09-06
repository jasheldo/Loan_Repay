library(tidyverse)
library(readxl)

data <- read_csv("Data/Most-Recent-Cohorts-All-Data-Elements.csv", col_types = cols(.default = 'c'))
dict <- read_excel("Data/CollegeScorecardDataDictionary.xlsx", sheet = "data_dictionary")

int_cols <- dict %>% filter(`API data type` == "integer") %>% select(`VARIABLE NAME`)
dbl_cols <- dict %>% filter(`API data type` == "float") %>% select(`VARIABLE NAME`)

data <- data %>% mutate_at(vars(which(names(data) %in% int_cols[[1]])), as.numeric) %>% 
    mutate_at(vars(which(names(data) %in% dbl_cols[[1]])), as.double)
