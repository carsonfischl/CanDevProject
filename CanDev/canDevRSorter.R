library(dplyr)
library(tidytext)
library(tidyverse)
library(readtext)
library(janeaustenr)
library(tm)
library(compare)

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


courseAssociations <- dt_matrix[dt_matrix$word %in% df$word,]
sortedCount <- courseAssociations[courseAssociations == count(courseAssociations$word, sort = TRUE)]
uniqueWords <- courseAssociations[courseAssociations == unique(courseAssociations$Title),] 

dev.off()