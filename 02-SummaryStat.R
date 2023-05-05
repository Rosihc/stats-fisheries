
# Loading libraries -------------------------------------------------------

library(dplyr)
library(RMySQL)
library(odbc)
library(tidyverse)

# establish connection to db ----------------------------------------------

# connection details
host= "goc-rds-production.cbujotn7bqi9.us-east-1.rds.amazonaws.com"
port = 3306
dbname = "fishing_tracker"
user = "blueprints"


# This connects to the database (creates an image, does not actually download anything)
my_db = dbConnect(RMySQL::MySQL(),
                  dbname=dbname,
                  host=host,
                  port=port,
                  user=user,
                  password=rstudioapi::askForPassword("Database password"))



fishingData <- tbl(my_db, "FishingData")

resource <- tbl(my_db, "Resource")

test <- left_join(fishingData, resource, by = "IDResource")

glimpse(test)            
glimpse(fishingData)            


dbListTables(my_db)

v_FishingData
tbl(my_db, "Trips") %>% glimpse()     


trips <- tbl(my_db, "Trips")
communities <- tbl(my_db, "Communities")
trip_community <- left_join(trips, communities, by = "IDCommunity") 


### Summary statistic 

summary <- trip_community %>% 
            group_by(IDCommunity, Name, Region) %>% 
            summarise(n_trips = n_distinct(IDTrip))



summary <- collect(summary) # DO NOT RUN IF SLOW CONNECTIOOON!!!!

View(summary)



