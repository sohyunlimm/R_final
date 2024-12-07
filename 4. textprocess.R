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

### 4. Text Analysis

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


### 4-1. Sentimental analysis - article

text_data <- article_section

# Analyze overall sentiment of the article
overall_sentiment <- sentiment(text_data)

# Calculate Polarity :  -0.04598272 (slightly negative)
polarity <- mean(overall_sentiment$sentiment)

# Calculate Subjectivity : 0.9540173 (relatively subject) 0~1
subjectivity <- 1 - abs(polarity)

# Print the Outcome
cat("Overall Polarity (Positive/Negative):", polarity, "\n")
cat("Overall Subjectivity (Objective/Subjective):", subjectivity, "\n")


### 4-2. Sentimental analysis - sentence

text_data <- article_section

# Divide the article by sentence
sentences <- get_sentences(text_data)

# Run the sentimental analysis
sentiment_results <- sentiment(sentences)

# Check the outcome dataframe
head(sentiment_results)

# Arrange the data for visualization
plot_data <- sentiment_results %>%
  group_by(sentence_id) %>%
  summarise(sentiment = mean(sentiment))

# Add number to the sentence
plot_data$sentence_number <- seq_along(plot_data$sentence_id)

# Create a graph
sentence <- ggplot(plot_data, aes(x = sentence_number, y = sentiment)) +
  geom_line(color = "blue", size = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +  
  labs(
    title = "Sentence Polarity of Article",
    x = "Sentence Number",
    y = "Polarity"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 12, face = "bold"),
    axis.text.y = element_text(size = 12, face = "bold")
  )

sentence

sentence_path <- "/Users/sohyunlim/Desktop/R_final_project/images/4-1_sentence_polarity_plot.png"
ggsave(filename = sentence_path, plot = sentence, width = 10, height = 6, dpi = 300)


### 4-3. Word frequency analysis - word

# Convert text data into the dataframe format
text_df <- data.frame(text = article_section, stringsAsFactors = FALSE)

# Tokenize the text and remove stop words
custom_stopwords <- data.frame(word = c("said", "jones", "riggins", "thomas", "sinclair"), 
                               lexicon = "custom")
word_freq <- text_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words, by = "word") %>%
  anti_join(custom_stopwords, by = "word") %>%
  count(word, sort = TRUE)

# Check top 10 words
top_words <- head(word_freq, 10)
print(top_words)

# Create a bar graph with words frequency
word_frq <- ggplot(top_words, aes(x = reorder(word, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top 10 Most Frequent Words",
    x = "Word",
    y = "Frequency"
  ) +
  theme_minimal() + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 12, face = "bold"),
    axis.text.y = element_text(size = 12, face = "bold")         
  )

word_frq

word_frq_path <- "/Users/sohyunlim/Desktop/R_final_project/images/4-2_word_frequency.png"
ggsave(filename = word_frq_path, plot = word_frq, width = 10, height = 6, dpi = 300)

