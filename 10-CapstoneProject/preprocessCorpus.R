preprocessCorpus <- function(corpus, profanityDict, removeStopwords = FALSE) {
  # remove punctuation
  corpus <- tm_map(corpus, removePunctuation)
  #remove numbers
  corpus <- tm_map(corpus, removeNumbers)
  #convert to lowercase
  corpus <- tm_map(corpus, tolower)
  #remove stopwords
  if (removeStopwords) {
    corpus <- tm_map(corpus, removeWords, stopwords("english"))
  }
  #remove profanity
  if (!missing(profanityDict)) {
    corpus <- tm_map(corpus, removeWords, profanity)
  }
  #strip whitespace
  corpus <- tm_map(corpus, stripWhitespace)
  #treat as text
  corpus <- tm_map(corpus, PlainTextDocument)
}
