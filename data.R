library(readxl)
library(dplyr)
library(sqldf)

temp_pop <- read_excel("~/project/Math503-Final/seattle temp & pop data.xlsx")
crime_data <- read_excel("~/project/Math503-Final/seattle crime data.xlsx")

crime_data_ymd <- data.frame(crime_data,
                 YEAR = as.numeric(format(crime_data$REPORT_DATE, format = "%Y")),
                 MONTH = as.numeric(format(crime_data$REPORT_DATE, format = "%m")),
                 DAY = as.numeric(format(crime_data$REPORT_DATE, format = "%d")))

temp_data_ymd <- data.frame(temp_pop,
                            MONTH = as.numeric(format(temp_pop$`Date (monthly)`, format = "%m")),
                            DAY = as.numeric(format(temp_pop$`Date (monthly)`, format = "%d")))

crime_types <- sqldf('SELECT * FROM crime_data_ymd group by CRIME_TYPE')

crime_data_ymd <- sqldf('SELECT *,  (YEAR || " " || MONTH) as YEAR_MONTH FROM crime_data_ymd')
temp_data_ymd <- sqldf('SELECT *,  (YEAR || " " || MONTH) as YEAR_MONTH FROM temp_data_ymd')
crime_data_grouped_year <- sqldf('SELECT *, SUM(STAT_VALUE) as total  FROM crime_data_ymd GROUP BY CRIME_TYPE, YEAR') 
crime_data_grouped_year_month <- sqldf('SELECT *, SUM(STAT_VALUE) as total, (YEAR || " " || MONTH) as YEAR_MONTH  FROM crime_data_ymd GROUP BY CRIME_TYPE,YEAR_MONTH')

final <- sqldf('SELECT cr.YEAR ,cr.MONTH, temp_data_ymd.`average.temp.F.` as temp, temp_data_ymd.population as pop, 
                          (SELECT total FROM crime_data_grouped_year as temp WHERE CRIME_TYPE = "Assault"  AND temp.year_month = cr.year_month) as Assault,  
                          (SELECT total FROM crime_data_grouped_year as temp WHERE CRIME_TYPE = "Burglary" AND temp.year_month = cr.year_month) as Burglary,
                          (SELECT total FROM crime_data_grouped_year as temp WHERE CRIME_TYPE = "Rape"     AND temp.year_month = cr.year_month) as Rape,
                          (SELECT total FROM crime_data_grouped_year as temp WHERE CRIME_TYPE = "Robbery"  AND temp.year_month = cr.year_month) as Robbery,
                          (SELECT total FROM crime_data_grouped_year as temp WHERE CRIME_TYPE = "Homicide"  AND temp.year_month = cr.year_month) as Homicide,
                          (SELECT total FROM crime_data_grouped_year as temp WHERE CRIME_TYPE = "Larceny-Theft"  AND temp.year_month = cr.year_month) as `Larceny-Theft`,
                          (SELECT total FROM crime_data_grouped_year as temp WHERE CRIME_TYPE = "Motor Vehicle Theft"  AND temp.year_month = cr.year_month) as `Motor Vehicle Theft`
                           FROM crime_data_grouped_year as cr JOIN temp_data_ymd ON cr.year = temp_data_ymd.year AND cr.month = temp_data_ymd.month ')


final <- sqldf('SELECT *, (Assault + Burglary + Rape + Robbery + Homicide + `Larceny-Theft` + `Motor Vehicle Theft`) as total FROM final')








 
