#Assumes input has already been processed.
#words is a char vector of length 3
#returns the top 5 predictions of the model
library(slam)
library(matrix)

predictNextWord <- function(words, dict, matrix4Gram, matrix3Gram, matrix2Gram, trieIdx) {
  
  idxUnk <- longest_match(trie = 'trieIdx', to_match = '<UNK>')
  idx <- c(idxUnk, idxUnk, idxUnk)
  
  for (k in 1:3) {
    #ok, using the trie map from words to index in the dictionary
    if (words[k] %in% myDict) {
      idx[k] <- longest_match(trie = 'trieIdx', to_match = words[k])
    }
  }
  
  wordsArray <- drop_simple_sparse_array(matrix4Gram[idx[1], idx[2], idx[3], ])
  
  numMatches <- nnzero(wordsArray$v)
  
  if ( numMatches >= 5) {
    topFreq <- tail(sort.int(wordsArray$v, partial = length(wordsArray$v) - 4), 5)
    topIdx <- wordsArray$i[topFiveFreq]
  } else if ( numMatches > 0 ) {
    topFreq <- tail(sort.int(wordsArray$v, partial = length(wordsArray$v) - (numMatches-1)), numMatches)
    topIdx <- wordsArray$i[topFiveFreq]
  } else { # todo 
    
  }
  #order <- order(wordsArray, decreasing = TRUE)
  
  #if necessary
  #predictWithTrigram(words(2:3), dict, matrix3Gram, matrix2Gram, trieIdx)
}