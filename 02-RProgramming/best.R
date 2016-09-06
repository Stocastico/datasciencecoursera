## the function finds the best hospital in a state.
## It takes two parameters as input, the 2-characters
## abbreviated name of a state and an outcome name.
## The function then reads the outcome-of-care-measures.csv
## file and return a characters vector with the name of
## the hospital with the best (lowest) 30-day mortality
## for the specified outcome in that state. Possible
## outcomes are 'heart attack', 'heart failure', 'pneumonia'.
## Hospitals that do not have data on a particular outcome
## are excluded from the set of hospitals when deciding
## the rankings. In case of a tie, an alphabetical sorting
## decides the best hospital

best <- function(state, outcome) {
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  stateCol <- 7
  nameCol <- 2

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

  ## Return hospital name in that state with lowest
  ## mortality rate
  subData <- data[, c(nameCol, stateCol, outcomeCol)]
  names(subData)[3] <- 'Outcome' #rename column
  subData <- subData[ subData$State == state, ]
  subData[, 3] <- as.numeric(subData[, 3]) #otherwise it's lexigographical order
  ordered <- subData[order(subData$Outcome, subData$Hospital.Name), ]
  ordered[1,1]
}
