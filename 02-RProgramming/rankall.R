rankall <- function(outcome, num = "best") {
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  nameCol <- 2
  stateCol <- 7

  ## Check that outcome is valid
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
  subData[, 3] <- as.numeric(subData[, 3]) #otherwise it's lexigographical order
  subData <- subData[complete.cases(subData[, 3]), ]

  ## For each state, find the hospital of the given rank
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  ##
  states <- sort(unique(subData[,2]))
  n <- length(states)
  name <- character(n)
  state <- character(n)
  for (i in 1:n) {
    state[i] <- states[i]
    temp <- subData[ subData$State == states[i], ]
    ordered <- temp[order(temp$Outcome, temp$Hospital.Name), ]
    ordered <- ordered[complete.cases(ordered[, 3]), ] # remove NAs
    ## convert num in case it has value 'best' or 'worst'
    if (num == 'best') idx <- 1
    else if (num == 'worst') idx <- nrow(ordered)
    else idx <- num
    if (idx <= nrow(ordered)) {
      name[i] <- ordered[idx, 1]
    } else {
      name[i] <- NA
    }
  }
  data.frame(name, state, stringsAsFactors=FALSE)

}
