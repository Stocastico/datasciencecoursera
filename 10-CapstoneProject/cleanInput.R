#Takes a sentence in input and provide the last three words as output
#If less than three words available, add start of sentence markers

cleanInput <- function(sentence) {
  input <- unlist(strsplit(as.character(sentence), " "))
  numWords <- length(input)
  if (numWords > 3) {
    words <- input[(numWords-2):numWords]
  }
  else if (length(input)  == 2) {
    words <- c('<s>', input)
  }
  else if (length(input)  == 1) {
    words <- c('<s>', '<s>', input)
  }
  else {
    words <- input
  }
  words
}