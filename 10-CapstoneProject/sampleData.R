sampleData <- function(data, samplingFactor) {
  numTexts <- length(data)
  subset <- character()
  for (i in 1:numTexts) {
    tmp <- data[[i]]
    subset <- c(subset, tmp[1 == rbinom(length(tmp), 1, samplingFactor)])
  }
  subset
}
