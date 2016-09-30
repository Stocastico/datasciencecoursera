predictNextWord <- function(sentence, dict, matrix4Gram, matrix3Gram, matrix2Gram, trieIdx) {
  input <- unlist(strsplit(sentence, " "))
  numWords <- length(input)
  if (numWords >= 3) {
    words <- input[numWords-2:numWords]
  }
  else if (length(input)  == 2) {
    words <- c('<s>', words)
  }
  else if (length(input)  == 1) {
    words <- c('<s>', '<s>', words)
  }
  else {
    words <- input
  }
  
  #ok, now words has length 3. Check that first word is in dictionary
  if (words[1] %in% myDict) {
    
  }
  else {
    predictWithTrigram(words(2:3), dict, matrix3Gram, matrix2Gram, trieIdx)
  }
}