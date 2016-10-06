#Assumes input has already been processed.
#word is a char vector of length 1
#returns the top-N predictions of the model
library(slam)

predictWithBigram <- function(word, dict, matrix2Gram, numPredictions) {

  idxUnk <- match('<UNK>', dict)
  idx <- idxUnk

  if (word %in% dict) {
    idx <- match(word, dict)
  }

  wordsArray <- drop_simple_sparse_array(matrix2Gram[idx, ])
  numMatches <- length(wordsArray$v)

  if (numMatches >= numPredictions) {
    ord <- order(wordsArray$v, decreasing = TRUE)
    topIdx <- wordsArray$i[ord[1:numPredictions]]
    prediction <- myDict[topIdx]
    return(prediction)
  } else if ( numMatches > 0 ) {
    ord <- order(wordsArray$v, decreasing = TRUE)
    topIdx <- wordsArray$i[ord[1:numMatches]]
    wordPred <- dict[1:numPredictions-numMatches]
    prediction <- c(myDict[topIdx], wordPred)
    return(prediction)
  } else { # No matches found!
    return(dict[1:numPredictions])
  }
}
