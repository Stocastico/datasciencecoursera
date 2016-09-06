## The function reads the outcome-of-care-measures.csv file
## and returns a character vector with the name of the hospital
## that has the ranking specified by the num argument.
## The num argument can take values "best", "\"worst", or an
## integer indicating the ranking (smaller numbers are better).
## If the number given by num is larger than the number of
## hospitals in that state, then the function should return NA.
## Hospitals that do not have data on a particular outcome should
## be excluded from the set of hospitals when deciding the rankings.

rankhospital <- function(state, outcome, num) {
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  nameCol <- 2
  stateCol <- 7

  ## Check that state and outcome are valid
  stateList <- data[, stateCol]
  if (! (state %in% stateList)) {
    stop("Invalid state")
  }

  if (outcome == 'heart attack') {
    outcomeCol <- 11
  } else if (outcome == 'heart failure') {
    outcomeCol <- 17
  } else if (outcome == 'pneumonia') {
    outcomeCol <- 23
  } else {
    stop("Invalid outcome")
  }

  ## Subset the data to simplify computation
  subData <- data[, c(nameCol, stateCol, outcomeCol)]
  names(subData)[3] <- 'Outcome' #rename column
  subData <- subData[ subData$State == state, ]
  subData[, 3] <- as.numeric(subData[, 3]) #otherwise it's lexigographical order
  subData <- subData[complete.cases(subData[, 3]), ]

  ## convert num in case it has value 'best' or 'worst'
  if (num == 'best') num <- 1
  else if (num == 'worst') num <- nrow(subData)

  ## Return hospital name in that state with the given rank
  ## 30-day death rate
  ordered <- subData[order(subData$Outcome, subData$Hospital.Name), ]
  ordered[num, 1]
}
