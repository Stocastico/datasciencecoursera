#Assumes input has already been processed.
#words is a char vector of length 2
#returns the top-N predictions of the model
library(slam)

predictWithTrigram <- function(words, dict, matrix3Gram, matrix2Gram, numPredictions) {
  
  idxUnk <- match('<UNK>', dict)
  idx <- c(idxUnk, idxUnk)
  
  for (k in 1:2) {
    if (words[k] %in% dict) {
      idx[k] <- match(words[k], dict)
    }
  }
  
  wordsArray <- drop_simple_sparse_array(matrix3Gram[idx[1], idx[2], ])
  numMatches <- length(wordsArray$v)
  
  if (numMatches >= numPredictions) {
    ord <- order(wordsArray$v, decreasing = TRUE)
    topIdx <- wordsArray$i[ord[1:numPredictions]]
    myDict[topIdx]
  } else if ( numMatches > 0 ) {
    ord <- order(wordsArray$v, decreasing = TRUE)
    topIdx <- wordsArray$i[ord[1:numMatches]]
    bigramPred <- predictWithBigram(words(2), dict, matrix2Gram)
    c(myDict[topIdx], bigramPred[1:numPredictions-numMatches])
  } else { # No matches found! 
    bigramPred <- predictWithBigram(words(2), dict, matrix2Gram, numPredictions)
    bigramPred
  }
}