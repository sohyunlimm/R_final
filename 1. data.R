library(tidyverse)
library(ggplot2)
library(rvest)
library(stats)
library(rvest)
library(sentimentr)
library(tidytext)
library(sf)
library(stringr)
library(shiny)
library(dplyr)
library(shinyWidgets)

# Set the directory
setwd("/Users/sohyunlim/Desktop/R_final_project")

# Load the dataset

### 1. Chicago public health statistics (https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected-public-health-in/iqnk-2tcu/about_data)

data <- read.csv("data/Public_Health_Statistics_-_Selected_public_health_indicators_by_Chicago_community_area_-_Historical_20241031.csv")

# Change column names
colnames(data) <- colnames(data) %>%
    tolower() %>%
    str_replace_all(fixed("."), "_") %>% 
    str_replace_all("__", "_") %>%
    str_replace("_$", "")   

# Select necessary columns
data <- data %>% select(community_area, community_area_name, 
                        cancer_all_sites, diabetes_related,
                        below_poverty_level, unemployment, per_capita_income)



### 2. Text data scraped from CBS News Article (https://www.cbsnews.com/chicago/news/cancer-care-disparities-1/)

# URL
url <- "https://www.cbsnews.com/chicago/news/cancer-care-disparities-1/"

# Load the web page and parse
page <- read_html(url)

# Extract the article content
article_section <- page %>%
  html_nodes(".content__body") %>%  
  html_text() %>%                   
  str_replace_all("\\s+", " ") %>%  
  str_squish()                      

# Save as txt. format.
file_path <- "/Users/sohyunlim/Desktop/R_final_project/data/article_content.txt"  
cat(article_section, file = file_path, sep = "\n")


### 3. Data for geospatial analysis
# 3-1. Chicago Public Health Service Map (https://data.cityofchicago.org/Health-Human-Services/Map-Public-Health-Services-Chicago-Primary-Care-Co/2usn-w2nz)

# Read csv file
healthcare_data <- read.csv("/Users/sohyunlim/Desktop/R_final_project/data/Map_-_Public_Health_Services_-_Chicago_Primary_Care_Community_Health_Centers.csv")

# Fix the column names
colnames(healthcare_data) <- colnames(healthcare_data) %>%
    tolower() %>%
    str_replace_all(fixed("."), "_") %>% 
    str_replace_all("__", "_") %>%
    str_replace("_$", "")   

head(healthcare_data)

# Extract latitude and longitude from Address
extract_lat_lon <- function(address) {
  match <- str_match(address, "\\(([-+]?[0-9]*\\.?[0-9]+), ([-+]?[0-9]*\\.?[0-9]+)\\)")
  if (!is.na(match[1, 1])) {
    return(c(as.numeric(match[1, 2]), as.numeric(match[1, 3])))
  } else {
    return(c(NA, NA))
  }
}

# Add latitude and longitude columns
lat_lon <- t(apply(as.data.frame(healthcare_data$address), 1, extract_lat_lon))
healthcare_data$latitude <- lat_lon[, 1]
healthcare_data$longitude <- lat_lon[, 2]

head(healthcare_data[, c("facility", "latitude", "longitude")])

# Drop NA 
healthcare_data <- healthcare_data %>% filter(!is.na(latitude) & !is.na(longitude))

# Convert into sf 
points_sf <- st_as_sf(
  healthcare_data,
  coords = c("longitude", "latitude"),
  crs = 4326  
)


# 3-2. Chicago geographical information_shape file (https://www.lib.uchicago.edu/e/collections/maps/chigis.html) 

# Rad Shapefile 
chi_shp <- st_read("/Users/sohyunlim/Desktop/R_final_project/data/Comm_20Areas__1_/CommAreas.shp")
print(chi_shp)

# Check CRS
chi_shp <- st_transform(chi_shp, crs = 4326)
points_sf <- st_transform(points_sf, crs = 4326)

# Set the range of longitude and latitude of Chicago
chi_longitude_range <- c(-88, -87.5)  
chi_latitude_range <- c(41.6, 42)    


# Merge chicago shp and health dataset

# Chicago shape file : chi_shp
# Chicago health dataset : data

# Fix the column names
colnames(chi_shp) <- colnames(chi_shp) %>%
    tolower() %>%
    str_replace_all(fixed("."), "_") %>% 
    str_replace_all("__", "_") %>%
    str_replace("_$", "")  

# Change column name in the shp file.
chi_shp <- chi_shp %>%
  rename(community_area = area_num_1)  

chi_shp$community_area <- as.numeric(chi_shp$community_area)
data$community_area <- as.numeric(data$community_area)

# Merge data
merged_data <- chi_shp %>%
  left_join(data, by = "community_area")

