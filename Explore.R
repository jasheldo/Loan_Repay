library(tidyverse)
library(readxl)
library(leaflet)
library(RColorBrewer)
library(htmlwidgets)

data <- read_csv("https://ed-public-download.app.cloud.gov/downloads/Most-Recent-Cohorts-All-Data-Elements.csv", 
                 col_types = cols(.default = 'c'))

url <- "https://collegescorecard.ed.gov/assets/CollegeScorecardDataDictionary.xlsx"
destfile <- "Data/CollegeScorecardDataDictionary.xlsx"
curl::curl_download(url, destfile)
dict <- read_excel(destfile, sheet = "data_dictionary")

int_cols <- dict %>% filter(`API data type` == "integer") %>% select(`VARIABLE NAME`)
dbl_cols <- dict %>% filter(`API data type` == "float") %>% select(`VARIABLE NAME`)

data <- data %>% mutate_at(vars(which(names(data) %in% int_cols[[1]])), as.numeric) %>% 
    mutate_at(vars(which(names(data) %in% dbl_cols[[1]])), as.double)


# Map the School Locations ------------------------------------------------


leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>% 
    addMarkers(data=data, lat=~LATITUDE, lng=~LONGITUDE, label = ~INSTNM, 
               clusterOptions=markerClusterOptions())


