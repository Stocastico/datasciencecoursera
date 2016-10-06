#Assumes input has already been processed.
#words is a char vector of length 3
#returns the top-N predictions of the model
library(slam)

#object visible across all sessions, containing my ngram frequencies
load('./data/singleWordsInfo.rda')
load('./data/sparseMatrices.rda')

predictNextWord <- function(words, dict, matrix4Gram, matrix3Gram, matrix2Gram, numPredictions) {

  if (is.null(words)) {
    prediction <- ""
    return(prediction)
  }

  LENGTH = length(words)

  if ( 0 == LENGTH) {
    prediction <- ""
    return(prediction)
  }

  idxUnk <- match('<UNK>', dict)
  idx <- rep.int(idxUnk, LENGTH)

  for (k in 1:LENGTH) {
    if (words[k] %in% dict) {
      idx[k] <- match(words[k], dict)
    }
  }

  if (3 == LENGTH) {
    wordsArray <- drop_simple_sparse_array(matrix4Gram[idx[1], idx[2], idx[3], ])

    numMatches <- length(wordsArray$v)

    if (numMatches >= numPredictions) {
      ord <- order(wordsArray$v, decreasing = TRUE)
      topIdx <- wordsArray$i[ord[1:numPredictions]]
      prediction <- myDict[topIdx]
      return(prediction)
    } else if ( numMatches > 0 ) {
      ord <- order(wordsArray$v, decreasing = TRUE)
      topIdx <- wordsArray$i[ord[1:numMatches]]
      trigramPred <- predictWithTrigram(words[2:3], dict, matrix3Gram, matrix2Gram, numPredictions-numMatches)
      prediction <- c(myDict[topIdx], trigramPred)
      return(prediction)
    } else { # No matches found!
      trigramPred <- predictWithTrigram(words[2:3], dict, matrix3Gram, matrix2Gram, numPredictions)
      return(trigramPred)
    }
  }
  else if (2 == LENGTH) {
    trigramPred <- predictWithTrigram(words, dict, matrix3Gram, matrix2Gram, numPredictions)
    return(trigramPred)
  }
  else { # 1 == LENGTH
    bigramPred <- predictWithBigram(words, dict, matrix2Gram, numPredictions)
    return(bigramPred)
  }
}
