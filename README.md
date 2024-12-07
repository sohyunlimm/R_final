Sohyun Lim
Date Created:12/07/2024
Date Modified: 12/07/2024

1. Required R packages: 
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

2. Version of R used: 2023.03.1

3. Data
1) CBS News Article released in January 2024, with title of "Chicago's South, West Sides have many more cancer patients, less access to care" (https://www.cbsnews.com/chicago/news/cancer-care-disparities-1/)
2)  Chicago Public Health Statistics from Chicago Data Portal (https://data.cityofchicago.org/Health-Human-Services/Public-Health-Statistics-Selected- public-health-in/iqnk-2tcu/about_data)
: This dataset contains a selection of 27 indicators of public health significance by Chicago community area, with the most updated information available. The indicators are rates, percents, or other measures related to natality, mortality, infectious disease, lead poisoning, and economic status. The dataset is last updated on February 3, 2022. Among the various indicators, I chose key indicators to use as below:
- Health outcomes: Cancer and diabetes mortality rates (per 100,000 persons, age-adjusted).
- Socioeconomic status: Poverty rate, unemployment rate, and per capita income.
3) Chicago Public Health Service Map (https://data.cityofchicago.org/Health-Human- Services/Map-Public-Health-Services-Chicago-Primary-Care-Co/2usn-w2nz)
: This dataset includes geographic locations of primary care health centers in Chicago.
4) Chicago Community Area Boundaries_shp file (https://data.cityofchicago.org/Facilities-Geographic-Boundaries/Boundaries-Community-Areas-current-/cauq-8yn6)
: Current community area boundaries in Chicago


4. Summary of code 
This code is for the final research project to explore the relationship between socioeconomic indicators and public health in Chicago. 
1) data.R
: In this file, all the dataset used for the research has been loaded. Also, it includes all the process of data wrangling, data cleaning as well as saving text file scraped from the news article that would be used for text analysis.
2) staticplot.R
: This file includes various visualizations such as bar graphs of top 10 areas with socioeconomic challenges and serious healthcare outcomes. Also, a diverse of choropleth maps were created to show the distribution of each indicators within Chicago.
3) shinyapp.R
: This file includes codes to run the shiny app which makes the analysis more interactive and helps people get more information on socioeconomic indicators and health outcomes related to healthcare accessibility.
4) textprocess.R
: This file includes web scraping and text analysis of the news article scraped from the website. For the text analysis, polarity, sentiment analysis, and word frequency analysis were used.
5) model.R
: This file includes codes for 6 linear regression models and scatter plots created based on each models. Three socioeconomic indicators including poverty, unemployment, and income were used for independent variables for each model, and two health outcomes such as cancer and diabetes were used for dependent variables for each model.


5. Images
1) 2-1 ~ 2-5 : These images show the list of top 10 areas of each with socioeconomic challenges and serious healthcare outcomes. From the graph, we can see that communities in the south and west sides of Chicago experience higher poverty and unemployment rates, lower income levels, and poorer health outcomes.
2) 2-6 ~ 2-11 :  These images are choropleth maps illustrating the distribution of each indicators (poverty, unemployment, low income, cancer, and diabetes) across the Chicago community area. This clearly shows the disparity of socioeconomic factors and health outcomes and we can see that the south and west sides are suffering from socioeconomic and health outcome challenges.  This pattern suggests a strong link between socioeconomic disadvantage and health disparities.
3) 2-12 ~ 2-13 : These are maps created from the information obtained from 1) 2-1 ~ 2-5. 2-12 shows areas ranked within the top 10 for both highest cancer and diabetes mortality. Similarly, 2-13 illustrates areas ranked within the top 10 for all the socioeconomic indicators. It is clearly shown that these areas are primarily located in the south and west part of Chicago.
4) 4-1 ~ 4-2 : These images are showing the result of text analysis. 4-1 is the result of sentiment analysis by sentence showing that negative sentences were used overall, reflecting the serious tone of the article. 4-2 is illustrating the outcome of word frequency analysis, highlighting terms like "cancer", "access", and "south side", emphasizing a strong focus in disparities in specific areas.
5) 5-1 ~ 5-6 : These are scatter plots of 6 regression models ran by the codes in "model.R". 5-1~5-3 shows the result of each linear regression whose dependent variable is cancer and poverty, income, unemployment were used as an independent variable respectively. It shows that poverty and unemployment are positively associated with higher cancer while income is negatively associated with this health outcome. In a similar way, 5-4 ~ 5-6 shows the outcome of each linear regression whose dependent variable is diabetes and poverty, income, unemployment were used as an independent variable respectively. It shows that poverty and unemployment are positively associated with higher diabetes while income is negatively associated with this health outcome. Overall, this confirms that socioeconomic factors play a crucial role in shaping public health disparities.


6. Write-up
1) writeup.md : This file describes (1) motivation and research question, (2) data sources, (3) analysis that I applied for the research such as text analysis, descriptive statistics, and spatial analysis, (4) Shiny app, and (5) conclusion with key findings, policy implication and limitation of this reserach.
2) writeup.pdf : I created a pdf file in case the images are not shown in the writeup.md file.