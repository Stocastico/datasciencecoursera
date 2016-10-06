#Takes a sentence in input and provide the last three words as output
#If less than three words available, return just those words

cleanInput <- function(sentence) {
  #to lower case
  sentence <- tolower(sentence)

  #Remove punctuation, but keep apostrophe
  sentence <- gsub("[^[:alnum:][:space:]']", "", sentence)

  #Remove numbers
  sentence <- gsub("[[:digit:]]+", "", sentence)

  #Collapse whitespace
  sentence <- gsub("\\s+", " ", sentence)

  #Separate words
  input <- unlist(strsplit(as.character(sentence), " "))
  numWords <- length(input)

  #Extract words
  if (numWords > 3) {
    words <- input[(numWords-2):numWords]
  }
  else {
    words <- input
  }
  #Return
  return(words)
}
