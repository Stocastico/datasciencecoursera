findBestTrigram <- function(freqDF, text) {
  regex <- paste("^", text, " [a-z]+", sep = "")
  tf <- grepl(regex, freqDF[, 1])
  matches <- freqDF[tf, ]
  matchesOrd <- matches[with(matches, order(-freq)), ]
  matchesOrd
  #bestMatch <- matchesOrd[1, 1]
  #bestMatch
}
