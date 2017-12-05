library(readxl)
library(sqldf)
library(tidyr)

temp_pop <- read_excel("~/project/Math503-Final/seattle temp & pop data.xlsx")
crime_data <- read_excel("~/project/Math503-Final/seattle crime data.xlsx")

crime_final <- separate(crime_data,"Date (monthly)",c("Year","Month","Day"), sep = "-")