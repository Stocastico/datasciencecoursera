predictWithBigram <- function(words, dict, matrix2Gram, trieIdx) {
  # should call it only if we have just two words
  if (length(words) != 2) {
    stop("ERROR: call function with exactly 2 words")
  }
  
  #ok, now words has length 2. Check that first word is in dictionary
  if (words[1] %in% myDict) {
    # get the index of the word
  }
  else {
    # just output the most common words
    prediction <- c("said", "will", "just", "one", "like")
  }
}