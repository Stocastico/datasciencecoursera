predictWithTrigram <- function(words, dict, matrix3Gram, matrix2Gram, trieIdx) {
  # should call it only if we have just two words
  if (length(words) != 2) {
    stop("ERROR: call function with exactly 2 words")
  }
  
  #ok, now words has length 2. Check that first word is in dictionary
  if (words[1] %in% myDict) {
    
  }
  else {
    predictWithBigram(words(2), dict, matrix2Gram, trieIdx)
  }
}