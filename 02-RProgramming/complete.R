complete <- function( directory, id=1:332 ) {
  ## directory is a character vector representing the location
  ## of the CSV files
  ##
  ## id is an integer vector indicating the monitor ID numbers
  ## to be used
  ##
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor id number and 'nobs' is the
  ## number of complete cases
  ##

  nobs = numeric()

  for (i in id) {
    filename <- sprintf("%03d.csv", i)
    filePath <- file.path( directory, filename, fsep = .Platform$file.sep )
    data <- read.csv(filePath)
    dataClean <- data[complete.cases(data), ]
    nobs <- c( nobs, nrow(dataClean) )
  }
  data.frame(id, nobs)
}
