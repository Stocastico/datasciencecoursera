pollutantmean <- function( directory, pollutant, id=1:332 ) {
  ## directory is a character vector representing the location
  ## of the CSV files
  ##
  ## pollutant is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate"
  ##
  ## id is an integer vector indicating the monitor ID numbers
  ## to be used
  ##
  ## Returns the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  ##

  pollutantValues = numeric()

  for (i in id) {
    filename <- sprintf("%03d.csv", i)
    filePath <- file.path( directory, filename, fsep = .Platform$file.sep )
    data <- read.csv(filePath)
    pollutantValues <- c(pollutantValues, data[[pollutant]])
  }

  mean( pollutantValues, na.rm = TRUE )
}
