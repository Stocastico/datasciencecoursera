#Assumes input has already been processed.
#words is a char vector of length 3
#returns the top 5 predictions of the model

predictNextWord <- function(words, dict, matrix4Gram, matrix3Gram, matrix2Gram, trieIdx) {
  
  #ok, using the trie map from words to index in the dictionary
  if (words[1] %in% myDict) {
    
  }
  else {
    
  }
  
  #if necessary
  #predictWithTrigram(words(2:3), dict, matrix3Gram, matrix2Gram, trieIdx)
}