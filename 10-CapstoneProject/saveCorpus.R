saveCorpus <- function(corpus, file) {
  writeLines(as.character(corpus), con="file")
}