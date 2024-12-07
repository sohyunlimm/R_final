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

### 1. Load the data and fix the column names

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


### 2-1. Load the healthcare to prepare for the dataset for shiny app.

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


### 2-1. Load the shapefile to prepare for the dataset for shiny app.

# Rad Shapefile 
chi_shp <- st_read("/Users/sohyunlim/Desktop/R_final_project/data/Comm_20Areas__1_/CommAreas.shp")
print(chi_shp)

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


### 3. Shiny App

# Convert CRS (EPSG:4326)
chi_shp <- st_transform(chi_shp, crs = 4326)
points_sf <- st_transform(points_sf, crs = 4326)
merged_data <- st_transform(merged_data, crs = 4326)

# Set the boundary of the map
chi_longitude_range <- c(-88, -87.5)
chi_latitude_range <- c(41.6, 42)

ui <- fluidPage(
    titlePanel("Chicago Public Health Indicators and Healthcare Centers"),
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "variable",
                label = "Select Indicators to Display:",
                choices = c("Cancer Mortality" = "cancer_all_sites",
                            "Diabetes Mortality" = "diabetes_related",
                            "Below Poverty Level" = "below_poverty_level",
                            "Unemployment" = "unemployment",
                            "Per Capita Income" = "per_capita_income")
            ),
            switchInput(
                inputId = "show_healthcare",
                label = "Overlay Healthcare Centers",
                value = FALSE
            )
        ),
        mainPanel(
            plotOutput("map")
        )
    )
)

server <- function(input, output) {
    output$map <- renderPlot({
        selected_var <- input$variable
        show_healthcare <- input$show_healthcare

        base_map <- ggplot(data = merged_data) +
            geom_sf(aes_string(fill = selected_var), color = "gray", size = 0.2) +
            scale_fill_gradient(
                low = "lightblue",
                high = "darkblue",
                name = selected_var
            ) +
            labs(
                title = paste("Chicago Community Areas -", gsub("_", " ", selected_var))
            ) +
            coord_sf(
                xlim = chi_longitude_range,
                ylim = chi_latitude_range,
                expand = FALSE
            ) +
            theme_minimal() +
            theme(
                plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
                axis.text = element_blank(),
                axis.ticks = element_blank()
            )

        if (show_healthcare) {
    base_map <- base_map +
        geom_sf(data = points_sf, color = "red", size = 5, shape = 10) +
        coord_sf(
            xlim = chi_longitude_range,
            ylim = chi_latitude_range,
            expand = FALSE
        )
}

        base_map
    })
}

shinyApp(ui = ui, server = server)

