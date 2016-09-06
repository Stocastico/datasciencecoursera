computeDTM <- function( corpus, n = 1) {
  if (n == 1) {
    dtm <- DocumentTermMatrix(corpus)
  }
  else
  {
    NgramTokenizer <- function(x) unlist(lapply(ngrams(words(x), n), paste, collapse = " "), use.names = FALSE)
    dtm <- DocumentTermMatrix(corpus, control = list(tokenize = NgramTokenizer))
  }
  dtm
}
