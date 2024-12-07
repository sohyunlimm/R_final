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

# 5. Regression Model
# 5-1. Run a linear regression to study correlationship between socioeconomic factors and public health.

# 5-1-1. below_poverty_level ~ cancer_all_sites
model_1 <- lm(cancer_all_sites ~ below_poverty_level, data = data)
summary(model_1)

# 5-1-2. unemployment ~ cancer_all_sites
model_2 <- lm(cancer_all_sites ~ unemployment, data = data)
summary(model_2)

# 5-1-3. per_capita_income ~ cancer_all_sites
model_3 <- lm(cancer_all_sites ~ per_capita_income, data = data)
summary(model_3)

# 5-1-4. below_poverty_level ~ diabetes_related
model_4 <- lm(diabetes_related ~ below_poverty_level, data = data)
summary(model_4)

# 5-1-5. unemployment ~ diabetes_related
model_5 <- lm(diabetes_related ~ unemployment, data = data)
summary(model_5)

# 5-1-6. per_capita_income ~ diabetes_related
model_6 <- lm(diabetes_related ~ per_capita_income, data = data)
summary(model_6)


# 5-2. Create scatter plots.

# 5-2-1. below_poverty_level ~ cancer_all_sites
scatter_poverty_cancer <- ggplot(data, aes(x = below_poverty_level, y = cancer_all_sites)) +
  geom_point(color = "blue", size = 2) +  
  geom_smooth(method = "lm", color = "red", se = FALSE) +  
  labs(
    title = "Poverty Level and Cancer",
    x = "Below Poverty Level (%)",
    y = "Cancer (Mortality per 100,000 persons)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)  
  )

scatter_poverty_cancer

scatter_poverty_cancer_path <- "/Users/sohyunlim/Desktop/R_final_project/images/5-1_scatter_poverty_cancer.png"
ggsave(scatter_poverty_cancer_path, plot = scatter_poverty_cancer, width = 8, height = 6, dpi = 300)

# 5-2-2. unemployment ~ cancer_all_sites
scatter_unemployment_cancer <- ggplot(data, aes(x = unemployment, y = cancer_all_sites)) +
  geom_point(color = "blue", size = 2) +  
  geom_smooth(method = "lm", color = "red", se = FALSE) +  
  labs(
    title = "Unemployment and Cancer",
    x = "Unemployment (%)",
    y = "Cancer (Mortality per 100,000 persons)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)  
  )

scatter_unemployment_cancer

scatter_unemployment_cancer_path <- "/Users/sohyunlim/Desktop/R_final_project/images/5-2_scatter_unemplyoment_cancer.png"
ggsave(scatter_unemployment_cancer_path, plot = scatter_unemployment_cancer, width = 8, height = 6, dpi = 300)

# 5-2-3. per_capita_income ~ cancer_all_sites
scatter_income_cancer <- ggplot(data, aes(x = per_capita_income, y = cancer_all_sites)) +
  geom_point(color = "blue", size = 2) +  
  geom_smooth(method = "lm", color = "red", se = FALSE) +  
  labs(
    title = "Income and Cancer",
    x = "Income ($)",
    y = "Cancer (Mortality per 100,000 persons)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)  
  )

scatter_income_cancer

scatter_income_cancer_path <- "/Users/sohyunlim/Desktop/R_final_project/images/5-3_scatter_income_cancer.png"
ggsave(scatter_income_cancer_path, plot = scatter_income_cancer, width = 8, height = 6, dpi = 300)

# 5-2-4. below_poverty_level ~ diabetes_related
scatter_poverty_diabetes <- ggplot(data, aes(x = below_poverty_level, y = diabetes_related)) +
  geom_point(color = "blue", size = 2) +  
  geom_smooth(method = "lm", color = "red", se = FALSE) +  
  labs(
    title = "Poverty Level and Diabetes",
    x = "Below Poverty Level (%)",
    y = "Diabetes (Mortality per 100,000 persons)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)  
  )

scatter_poverty_diabetes

scatter_poverty_diabetes_path <- "/Users/sohyunlim/Desktop/R_final_project/images/5-4_scatter_poverty_diabetes.png"
ggsave(scatter_poverty_diabetes_path, plot = scatter_poverty_diabetes, width = 8, height = 6, dpi = 300)

# 5-2-5. unemployment ~ diabetes_related
scatter_unemployment_diabetes <- ggplot(data, aes(x = unemployment, y = diabetes_related)) +
  geom_point(color = "blue", size = 2) +  
  geom_smooth(method = "lm", color = "red", se = FALSE) +  
  labs(
    title = "Uemployment and Diabetes",
    x = "Uemployment (%)",
    y = "Diabetes (Mortality per 100,000 persons)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)  
  )

scatter_unemployment_diabetes

scatter_unemployment_diabetes_path <- "/Users/sohyunlim/Desktop/R_final_project/images/5-5_scatter_unemployment_diabetes.png"
ggsave(scatter_unemployment_diabetes_path, plot = scatter_unemployment_diabetes, width = 8, height = 6, dpi = 300)

# 5-2-6. per_capita_income ~ diabetes_related
scatter_income_diabetes <- ggplot(data, aes(x = per_capita_income, y = diabetes_related)) +
  geom_point(color = "blue", size = 2) +  
  geom_smooth(method = "lm", color = "red", se = FALSE) +  
  labs(
    title = "Income and Diabetes",
    x = "Income ($)",
    y = "Diabetes (Mortality per 100,000 persons)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5)  
  )

scatter_income_diabetes

scatter_income_diabetes_path <- "/Users/sohyunlim/Desktop/R_final_project/images/5-6_scatter_income_diabetes.png"
ggsave(scatter_income_diabetes_path, plot = scatter_income_diabetes, width = 8, height = 6, dpi = 300)


