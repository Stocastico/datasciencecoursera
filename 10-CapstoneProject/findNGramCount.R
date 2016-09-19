findNGramCount <- function(NGramDF, text) {
  regex <- paste("^", text, sep = "")
  tf <- grepl(regex, NGramDF[, 1])
  matches <- NGramDF[tf, ]
  matchesOrd <- matches[with(matches, order(-freq)), ]
  matchesOrd
}