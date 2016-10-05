#Assumes input has already been processed.
#words is a char vector of length 3
#returns the top-N predictions of the model
library(slam)

predictNextWord <- function(words, dict, matrix4Gram, matrix3Gram, matrix2Gram, numPredictions) {
  
  idxUnk <- match('<UNK>', dict)
  idx <- c(idxUnk, idxUnk, idxUnk)
  
  for (k in 1:3) {
    if (words[k] %in% dict) {
      idx[k] <- match(words[k], dict)
    }
  }
  
  wordsArray <- drop_simple_sparse_array(matrix4Gram[idx[1], idx[2], idx[3], ])
  
  numMatches <- length(wordsArray$v)
  
  if (numMatches >= numPredictions) {
    ord <- order(wordsArray$v, decreasing = TRUE)
    topIdx <- wordsArray$i[ord[1:numPredictions]]
    myDict[topIdx]
  } else if ( numMatches > 0 ) {
    ord <- order(wordsArray$v, decreasing = TRUE)
    topIdx <- wordsArray$i[ord[1:numMatches]]
    trigramPred <- predictWithTrigram(words[2:3], dict, matrix3Gram, matrix2Gram, numPredictions-numMatches)
    c(myDict[topIdx], trigramPred)
  } else { # No matches found! 
    trigramPred <- predictWithTrigram(words[2:3], dict, matrix3Gram, matrix2Gram, numPredictions)
    trigramPred
  }
}