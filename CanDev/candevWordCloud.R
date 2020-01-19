library(dplyr)
library(tidytext)
library(tidyverse)
library(readtext)
library(janeaustenr)
library(wordcloud)
library(wordcloud2)
library(RColorBrewer)
library(tm)

file = read.csv("C:\Users\carso\OneDrive\Documents\candevAlternateData2", stringsAsFactors=FALSE)

file <- file[,1:2]

courses <- tibble(line = 1:398, text = file)


dt_matrix <-file %>%
    unnest_tokens(word, Description)

wordlist <- dt_matrix$word[nchar(dt_matrix$word) > 5]
gsub("you'll", "", wordlist)
gsub("[[:punct:]]", "", wordlist)
gsub("ourse", "", wordlist)
corpus <- Corpus(VectorSource(wordlist))

dtm <- TermDocumentMatrix(corpus) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq = words)

set.seed(1234)
wordcloud2(data=df, size=1.6, color='random-dark')

dev.off()