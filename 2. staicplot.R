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


# 1. Load the data and fix the column names

# Set the directory
setwd("/Users/sohyunlim/Desktop/R_final_project/")

# Load the dataset
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



# 2-1. Create a bar graph with top 10 community area by main variables

# Public Health Indicator 
# a, cancer_all_sites : Mortality per 100,000 persons
# b. diabetes_related : Mortality per 100,000 persons
# Socioeconomic Indicator
# a. below_poverty_level : Percent of households
# b. unemployment : Percent of persons in labor force aged 16 years and older
# c. per_capita_income : 2011 inflation-adjusted dollars


# Create a table for cancer_all_sites
cancer_areas <- data %>%
  select(community_area, community_area_name, cancer_all_sites) %>%
  arrange(desc(cancer_all_sites))
top_10_cancer_areas <- head(cancer_areas, 10)

diabetes_areas <- data %>%
  select(community_area, community_area_name, diabetes_related) %>%
  arrange(desc(diabetes_related))
top_10_diabetes_areas <- head(diabetes_areas, 10)

poverty_areas <- data %>%
  select(community_area, community_area_name, below_poverty_level) %>%
  arrange(desc(below_poverty_level))
top_10_poverty_areas <- head(poverty_areas, 10)

umemployment_areas <- data %>%
  select(community_area, community_area_name, unemployment) %>%
  arrange(desc(unemployment))
top_10_umemployment_areas <- head(umemployment_areas, 10)

income_areas <- data %>%
  select(community_area, community_area_name, per_capita_income) %>%
  arrange(per_capita_income)
top_10_income_areas <- head(income_areas, 10)


# Create a bar chart
# 2-1-1_top_10_cancer.png
bar_cancer <- ggplot(top_10_cancer_areas, aes(x = reorder(community_area_name, cancer_all_sites), y = cancer_all_sites)) +
  geom_bar(stat = "identity", fill = "#377EB8") +
  coord_flip() +
  labs(
    title = "Top 10 Community Areas with Highest Cancer Mortality",
    x = "Community Area",
    y = "Cancer (Mortality per 100,000 persons)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(size = 10, face = "bold")
  )

bar_cancer

bar_cancer_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-1_top_10_cancer.png"
ggsave(bar_cancer_path, plot = bar_cancer, width = 8, height = 6, dpi = 300)

# 2-1-2_top_10_diabetes.png
bar_diabetes <- ggplot(top_10_diabetes_areas, aes(x = reorder(community_area_name, diabetes_related), y = diabetes_related)) +
  geom_bar(stat = "identity", fill = "#377EB8") +
  coord_flip() +
  labs(
    title = "Top 10 Community Areas with Highest Diabetes Mortality",
    x = "Community Area",
    y = "Diabetes (Mortality per 100,000 persons)"
  ) +
  theme_minimal() + 
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(size = 10, face = "bold")
  ) + 
  scale_y_continuous(
    limits = c(0, 130),  
    breaks = seq(0, 125, by = 25)  
  )

bar_diabetes

bar_diabetes_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-2_top_10_diabetes.png"
ggsave(bar_diabetes_path, plot = bar_diabetes, width = 11, height = 6, dpi = 300)

# 2-1-3_top_10_poverty.png
bar_poverty <- ggplot(top_10_poverty_areas, aes(x = reorder(community_area_name, below_poverty_level), y = below_poverty_level)) +
  geom_bar(stat = "identity", fill = "#377EB8") +
  coord_flip() +
  labs(
    title = "Top 10 Community Areas with Highest Poverty Level",
    x = "Community Area",
    y = "Poverty (%)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(size = 10, face = "bold")
  )

bar_poverty

bar_poverty_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-3_top_10_poverty.png"
ggsave(bar_poverty_path, plot = bar_poverty, width = 8, height = 6, dpi = 300)

# 2-1-4_top_10_unemployment.png
bar_unemployment <- ggplot(top_10_umemployment_areas, aes(x = reorder(community_area_name, unemployment), y = unemployment)) +
  geom_bar(stat = "identity", fill = "#377EB8") +
  coord_flip() +
  labs(
    title = "Top 10 Community Areas with Highest Unemployment",
    x = "Community Area",
    y = "Unemployment (%)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(size = 10, face = "bold")
  )

bar_unemployment

bar_unemployment_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-4_top_10_unemployment.png"
ggsave(bar_unemployment_path, plot = bar_unemployment, width = 8, height = 6, dpi = 300)

# 2-1-5_top_10_income.png
bar_income <- ggplot(top_10_income_areas, aes(x = reorder(community_area_name, -per_capita_income), y = per_capita_income)) +
  geom_bar(stat = "identity", fill = "#377EB8") +
  coord_flip() +
  labs(
    title = "Top 10 Community Areas with Lowest Income",
    x = "Community Area",
    y = "Income ($)"
  ) +
  theme_minimal() + 
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(size = 10, face = "bold")
  )

bar_income

bar_income_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-5_top_10_income.png"
ggsave(bar_income_path, plot = bar_income, width = 8, height = 6, dpi = 300)



# 2-2. Geospatial analysis
# Load a shp file.

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


# Read Shapefile 
chi_shp <- st_read("/Users/sohyunlim/Desktop/R_final_project/data/Comm_20Areas__1_/CommAreas.shp")
print(chi_shp)


#. Chicago Health Center Map

# Check CRS
chi_shp <- st_transform(chi_shp, crs = 4326)
points_sf <- st_transform(points_sf, crs = 4326)

# Set the range of longitude and latitude of Chicago
chi_longitude_range <- c(-88, -87.5)  
chi_latitude_range <- c(41.6, 42)    

# Create a map
chicago_health_center <- ggplot() +
  geom_sf(data = chi_shp, fill = "lightgrey", color = "gray", alpha = 0.3) +  
  geom_sf(data = points_sf, color = "red", size = 2, shape = 21) +  
  labs(
    title = "Chicago Map with Healthcare Centers"
  ) +
  coord_sf(
    xlim = chi_longitude_range,  
    ylim = chi_latitude_range,  
    expand = FALSE
  ) +
  theme_void() +  
  theme(
    plot.title = element_text(
      hjust = 0.5,                
      size = 14,                  
      margin = margin(t = 10, b = 20)  
    )
  )

chicago_health_center

chicago_health_center_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-6_chicago_health_center.png"
ggsave(filename = chicago_health_center_path, plot = chicago_health_center, width = 10, height = 6, dpi = 300)


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


# 2-3. Chicago map with public health indicators

# 2-3-1. cancer_all_sites
map_cancer <- ggplot(data = merged_data) +
  geom_sf(aes(fill = cancer_all_sites), color = "gray", size = 0.2) +
  scale_fill_gradient(
    low = "lightblue",
    high = "darkblue",
    name = "Cancer (Mortality per 100,000 persons)"
  ) +
  labs(
    title = "Cancer MOrtality in Chicago Community Areas"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text = element_blank(),  
    axis.ticks = element_blank()
  )

map_cancer

map_cancer_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-7_chicago_cancer.png"
ggsave(filename = map_cancer_path, plot = map_cancer, width = 10, height = 6, dpi = 300)

# 2-3-2. diabetes_related
map_diabetes <- ggplot(data = merged_data) +
  geom_sf(aes(fill = diabetes_related), color = "gray", size = 0.2) +
  scale_fill_gradient(
    low = "lightblue",
    high = "darkblue",
    name = "Diabetes (Mortality per 100,000 persons)"
  ) +
  labs(
    title = "Diabetes Mortality in Chicago Community Areas"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text = element_blank(),  
    axis.ticks = element_blank()
  )

map_diabetes

map_diabetes_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-8_chicago_diabetes.png"
ggsave(filename = map_diabetes_path, plot = map_diabetes, width = 10, height = 6, dpi = 300)


# 2-4. Chicago map with socioeconomic indicators

# 2-4-1. below_poverty_level
map_poverty <- ggplot(data = merged_data) +
  geom_sf(aes(fill = below_poverty_level), color = "gray", size = 0.2) +
  scale_fill_gradient(
    low = "#FFF5B7",
    high = "red",
    name = "Poverty Level (%)"
  ) +
  labs(
    title = "Below Poverty Level by Chicago Community Areas"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text = element_blank(),  
    axis.ticks = element_blank()
  )

map_poverty

map_poverty_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-9_chicago_poverty.png"
ggsave(filename = map_poverty_path, plot = map_poverty, width = 10, height = 6, dpi = 300)

# 2-4-2. unemployment
map_unemployment <- ggplot(data = merged_data) +
  geom_sf(aes(fill = unemployment), color = "gray", size = 0.2) +
  scale_fill_gradient(
    low = "#FFF5B7",
    high = "red",
    name = "Unemployment (%)"
  ) +
  labs(
    title = "Unemployment by Chicago Community Areas"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text = element_blank(),  
    axis.ticks = element_blank()
  )

map_unemployment

map_unemployment_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-10_chicago_unemployment.png"
ggsave(filename = map_unemployment_path, plot = map_unemployment, width = 10, height = 6, dpi = 300)

# 2-4-3. per_capita_income
map_income <- ggplot(data = merged_data) +
  geom_sf(aes(fill = per_capita_income), color = "gray", size = 0.2) +
  scale_fill_gradient(
    low = "#FFF5B7",
    high = "#FF8040",
    name = "Income($)"
  ) +
  labs(
    title = "Income by Chicago Community Areas"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text = element_blank(),  
    axis.ticks = element_blank()
  )

map_income

map_income_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-11_chicago_income.png"
ggsave(filename = map_income_path, plot = map_income, width = 10, height = 6, dpi = 300)


# 2-5. Additional. Create a map showing health outcome and socioeconomic status in Chicago

# Top 10 regions overlapped regarding cancer and diabetes mortality
overlap_cancer_diabetes <- intersect(top_10_cancer_areas$community_area, top_10_diabetes_areas$community_area)

# Filter the data of those regions
overlap_data <- chi_shp %>% 
  filter(community_area %in% overlap_cancer_diabetes)

# Create a map
map_cancer_diabetes_overlap <- ggplot() +
  geom_sf(data = chi_shp, fill = "lightgrey", color = "gray", alpha = 0.3) + 
  geom_sf(data = overlap_data, fill = "red", color = "black", size = 0.2) +
  labs(
    title = "Top 10 Cancer & Diabetes Areas in Chicago"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold", margin = margin(t = 10, b = 20))
  )

map_cancer_diabetes_overlap

map_cancer_diabetes_overlap_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-12_top_10_overlap_health.png"
ggsave(map_cancer_diabetes_overlap_path, plot = map_cancer_diabetes_overlap, width = 8, height = 6, dpi = 300)


# Top 10 regions overlapped regarding highest poverty, unemplyoemtn, and low income
overlap_socioeconomic <- Reduce(intersect, list(
  top_10_poverty_areas$community_area,
  top_10_umemployment_areas$community_area,
  top_10_income_areas$community_area
))

# Filter the data of those regions
overlap_socioeconomic_data <- chi_shp %>% 
  filter(community_area %in% overlap_socioeconomic)

# Create a map
map_socioeconomic_overlap <- ggplot() +
  geom_sf(data = chi_shp, fill = "lightgrey", color = "gray", alpha = 0.3) + 
  geom_sf(data = overlap_socioeconomic_data, fill = "blue", color = "black", size = 0.2) +
  labs(
    title = "Top 10 Socioeconomic Indicators in Chicago"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold", margin = margin(t = 10, b = 20))
  )

map_socioeconomic_overlap

map_socioeconomic_overlap_path <- "/Users/sohyunlim/Desktop/R_final_project/images/2-13_top_10_overlap_socio.png"
ggsave(map_socioeconomic_overlap_path, plot = map_socioeconomic_overlap, width = 8, height = 6, dpi = 300)

