# CREATE A MODEL AFTER LOADING DATA
library(NLP)
library(tm)
library(SnowballC)
library(ggplot2)
library(stringi)
library(slam)
library(dplyr)
library(data.table)

source('~/Desktop/datasciencecoursera/10-CapstoneProject/importData.R')

#READ ALL
data <- importData('/home/masneris/Downloads/final/en_US/')
data <- c(data[[1]], data[[2]], data[[3]])

#Remove punctuation, but keep apostrophe
data <- gsub("[^[:alnum:][:space:]']", "", data)

NUM_CHUNKS <- 20

#SPLIT INTO 20 GROUPS
chunks <- split(data, ceiling(seq_along(data) / (length(data)/NUM_CHUNKS)))

#PROCESS UNIGRAM
myDocs <- list()
dtm_unigram <- list()
freq_unigram <- list()
for (k in 1:NUM_CHUNKS) {
  myDocs[[k]] <- Corpus(VectorSource(chunks[[k]]))
  # DATA PROPEROCESSING
  # remove punctuation
  myDocs[[k]] <- tm_map(myDocs[[k]], removePunctuation)
  #remove numbers
  myDocs[[k]] <- tm_map(myDocs[[k]], removeNumbers)
  #convert to lowercase
  myDocs[[k]] <- tm_map(myDocs[[k]], tolower)
  #remove stopwords
  myDocs[[k]] <- tm_map(myDocs[[k]], removeWords, stopwords("english"))
  #strip whitespace
  myDocs[[k]] <- tm_map(myDocs[[k]], stripWhitespace)
  #treat as text
  myDocs[[k]] <- tm_map(myDocs[[k]], PlainTextDocument)
  dtm_unigram[[k]] <- DocumentTermMatrix(myDocs[[k]], control=list(wordLengths=c(0,Inf)))
  freq_unigram[[k]] <- col_sums(dtm_unigram[[k]])
}
rm(myDocs)
rm(chunks)

# PUT ALL UNIGRAMS TOGETHER
tmp1 <- as.data.frame(freq_unigram[[1]])
colnames(tmp1) <- 'frequency'
tmp1 <- setDT(tmp1, keep.rownames = TRUE)[]
tmp2 <- as.data.frame(freq_unigram[[2]])
colnames(tmp2) <- 'frequency'
tmp2 <- setDT(tmp2, keep.rownames = TRUE)[]
freq_unigram_all <- full_join(tmp1, tmp2, by = 'rn')
freq_unigram_all[, frequency := sum(frequency.x, frequency.y, na.rm = TRUE), by = rn]
freq_unigram_all[, frequency.x := NULL]
freq_unigram_all[, frequency.y := NULL]
rm(tmp1, tmp2)
for (k in 3:20) {
  tmp <- as.data.frame(freq_unigram[[k]])
  colnames(tmp) <- 'frequency'
  tmp <- setDT(tmp, keep.rownames = TRUE)[]
  freq_unigram_all <- full_join(freq_unigram_all, tmp, by = 'rn')
  freq_unigram_all[, frequency := sum(frequency.x, frequency.y, na.rm = TRUE), by = rn]
  freq_unigram_all[, frequency.x := NULL]
  freq_unigram_all[, frequency.y := NULL]
}
rm(freq_unigram)


# THEN ADD START AND END OF SENTENCE MARKERS
for (k in 1:length(data)) {
  dataNoPunct[k] <- paste0('<s> ', data[k], ' </s>')
}

#SPLIT INTO 0 GROUPS
chunks <- split(dataNoPunct, ceiling(seq_along(dataNoPunct) / (length(dataNoPunct)/NUM_CHUNKS)))

#PROCESS BIGRAM
myDocs <- list()
dtm_bigram <- list()
freq_bigram <- list()
BigramTokenizer <- function(x) unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
for (k in 1:NUM_CHUNKS) {
  myDocs[[k]] <- Corpus(VectorSource(chunks[[k]]))
  # DATA PROPEROCESSING
  #remove numbers
  myDocs[[k]] <- tm_map(myDocs[[k]], removeNumbers)
  #convert to lowercase
  myDocs[[k]] <- tm_map(myDocs[[k]], tolower)
  #remove stopwords
  myDocs[[k]] <- tm_map(myDocs[[k]], removeWords, stopwords("english"))
  #strip whitespace
  myDocs[[k]] <- tm_map(myDocs[[k]], stripWhitespace)
  #treat as text
  myDocs[[k]] <- tm_map(myDocs[[k]], PlainTextDocument)
  dtm_bigram[[k]] <- DocumentTermMatrix(myDocs[[k]], control=list(tokenize = BigramTokenizer))
  freq_bigram[[k]] <- col_sums(dtm_bigram[[k]])
}
rm(myDocs)
rm(chunks)

# PUT ALL BIGRAMS TOGETHER
tmp1 <- as.data.frame(freq_bigram[[1]])
colnames(tmp1) <- 'frequency'
tmp1 <- setDT(tmp1, keep.rownames = TRUE)[]
tmp2 <- as.data.frame(freq_bigram[[2]])
colnames(tmp2) <- 'frequency'
tmp2 <- setDT(tmp2, keep.rownames = TRUE)[]
freq_bigram_all <- full_join(tmp1, tmp2, by = 'rn')
freq_bigram_all[, frequency := sum(frequency.x, frequency.y, na.rm = TRUE), by = rn]
freq_bigram_all[, frequency.x := NULL]
freq_bigram_all[, frequency.y := NULL]
rm(tmp1, tmp2)
for (k in 3:NUM_CHUNKS) {
  tmp <- as.data.frame(freq_bigram[[k]])
  colnames(tmp) <- 'frequency'
  tmp <- setDT(tmp, keep.rownames = TRUE)[]
  freq_bigram_all <- full_join(freq_bigram_all, tmp, by = 'rn')
  freq_bigram_all[, frequency := sum(frequency.x, frequency.y, na.rm = TRUE), by = rn]
  freq_bigram_all[, frequency.x := NULL]
  freq_bigram_all[, frequency.y := NULL]
}
rm(freq_bigram)

# NOW FOR THE TRIGRAM. ADD ANOTHER SYMBOL FOR START OF SENTENCE
dataNoPunctTri <- dataNoPunct
for (k in 1:length(dataNoPunct)) {
  dataNoPunctTri[k] <- paste0('<s> ', dataNoPunct[k])
}

#SPLIT INTO 20 GROUPS
chunks <- split(dataNoPunctTri, ceiling(seq_along(dataNoPunctTri) / (length(dataNoPunctTri)/NUM_CHUNKS)))

#PROCESS TRIGRAM
myDocs <- list()
dtm_trigram <- list()
freq_trigram <- list()
TrigramTokenizer <- function(x) unlist(lapply(ngrams(words(x), 3), paste, collapse = " "), use.names = FALSE)
for (k in 1:NUM_CHUNKS) {
  myDocs[[k]] <- Corpus(VectorSource(chunks[[k]]))
  # DATA PROPEROCESSING
  #remove numbers
  myDocs[[k]] <- tm_map(myDocs[[k]], removeNumbers)
  #convert to lowercase
  myDocs[[k]] <- tm_map(myDocs[[k]], tolower)
  #remove stopwords
  myDocs[[k]] <- tm_map(myDocs[[k]], removeWords, stopwords("english"))
  #strip whitespace
  myDocs[[k]] <- tm_map(myDocs[[k]], stripWhitespace)
  #treat as text
  myDocs[[k]] <- tm_map(myDocs[[k]], PlainTextDocument)
  dtm_trigram[[k]] <- DocumentTermMatrix(myDocs[[k]], control=list(tokenize = TrigramTokenizer))
  freq_trigram[[k]] <- col_sums(dtm_trigram[[k]])
}
rm(myDocs)
rm(chunks)

# PUT ALL TRIGRAMS TOGETHER
tmp1 <- as.data.frame(freq_trigram[[1]])
colnames(tmp1) <- 'frequency'
tmp1 <- setDT(tmp1, keep.rownames = TRUE)[]
tmp2 <- as.data.frame(freq_trigram[[2]])
colnames(tmp2) <- 'frequency'
tmp2 <- setDT(tmp2, keep.rownames = TRUE)[]
freq_trigram_all <- full_join(tmp1, tmp2, by = 'rn')
freq_trigram_all[, frequency := sum(frequency.x, frequency.y, na.rm = TRUE), by = rn]
freq_trigram_all[, frequency.x := NULL]
freq_trigram_all[, frequency.y := NULL]
rm(tmp1, tmp2)
for (k in 3:NUM_CHUNKS) {
  tmp <- as.data.frame(freq_trigram[[k]])
  colnames(tmp) <- 'frequency'
  tmp <- setDT(tmp, keep.rownames = TRUE)[]
  freq_trigram_all <- full_join(freq_trigram_all, tmp, by = 'rn')
  freq_trigram_all[, frequency := sum(frequency.x, frequency.y, na.rm = TRUE), by = rn]
  freq_trigram_all[, frequency.x := NULL]
  freq_trigram_all[, frequency.y := NULL]
}
rm(freq_trigram)

# NOW FOR THE QUADGRAM. ADD ANOTHER SYMBOL FOR START OF SENTENCE
dataNoPunctQuad <- dataNoPunctTri
for (k in 1:length(dataNoPunctTri)) {
  dataNoPunctQuad[k] <- paste0('<s> ', dataNoPunctTri[k])
}

#SPLIT INTO 20 GROUPS
chunks <- split(dataNoPunctQuad, ceiling(seq_along(dataNoPunctQuad) / (length(dataNoPunctQuad)/NUM_CHUNKS)))

#PROCESS QUADGRAM
myDocs <- list()
dtm_quadgram <- list()
freq_quadgram <- list()
QuadgramTokenizer <- function(x) unlist(lapply(ngrams(words(x), 4), paste, collapse = " "), use.names = FALSE)
for (k in 1:NUM_CHUNKS) {
  myDocs[[k]] <- Corpus(VectorSource(chunks[[k]]))
  # DATA PROPEROCESSING
  #remove numbers
  myDocs[[k]] <- tm_map(myDocs[[k]], removeNumbers)
  #convert to lowercase
  myDocs[[k]] <- tm_map(myDocs[[k]], tolower)
  #remove stopwords
  myDocs[[k]] <- tm_map(myDocs[[k]], removeWords, stopwords("english"))
  #strip whitespace
  myDocs[[k]] <- tm_map(myDocs[[k]], stripWhitespace)
  #treat as text
  myDocs[[k]] <- tm_map(myDocs[[k]], PlainTextDocument)
  dtm_quadgram[[k]] <- DocumentTermMatrix(myDocs[[k]], control=list(tokenize = QuadgramTokenizer))
  freq_quadgram[[k]] <- col_sums(dtm_quadgram[[k]])
}
rm(myDocs)
rm(chunks)

# PUT ALL QUADGRAMS TOGETHER
tmp1 <- as.data.frame(freq_quadgram[[1]])
colnames(tmp1) <- 'frequency'
tmp1 <- setDT(tmp1, keep.rownames = TRUE)[]
tmp2 <- as.data.frame(freq_quadgram[[2]])
colnames(tmp2) <- 'frequency'
tmp2 <- setDT(tmp2, keep.rownames = TRUE)[]
freq_quadgram_all <- full_join(tmp1, tmp2, by = 'rn')
freq_quadgram_all[, frequency := sum(frequency.x, frequency.y, na.rm = TRUE), by = rn]
freq_quadgram_all[, frequency.x := NULL]
freq_quadgram_all[, frequency.y := NULL]
rm(tmp1, tmp2)
for (k in 3:NUM_CHUNKS) {
  tmp <- as.data.frame(freq_quadgram[[k]])
  colnames(tmp) <- 'frequency'
  tmp <- setDT(tmp, keep.rownames = TRUE)[]
  freq_quadgram_all <- full_join(freq_quadgram_all, tmp, by = 'rn')
  freq_quadgram_all[, frequency := sum(frequency.x, frequency.y, na.rm = TRUE), by = rn]
  freq_quadgram_all[, frequency.x := NULL]
  freq_quadgram_all[, frequency.y := NULL]
}
rm(freq_quadgram, tmp)

# Save data
save(freq_unigram_all, freq_bigram_all, freq_trigram_all, freq_quadgram_all, file = '/storage/laur/Personal/MasneriStefano/data/freq_1234.rda')

# Clear memory
rm(list = ls())
gc()