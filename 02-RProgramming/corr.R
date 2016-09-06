corr <- function(directory, threshold = 0) {
  ## directory is a character vector representing the location
  ## of the CSV files
  ##
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; default is 0
  ##
  ## Return a numeric vector of correlations
  ##

  df <- complete(directory)
  nr <- nrow(df)
  correlations = numeric()
  for (i in df[, 1]) {
    if (df[i,2] > threshold) {
      filename <- sprintf("%03d.csv", i)
      filePath <- file.path( directory, filename, fsep = .Platform$file.sep )
      data <- read.csv(filePath)
      newCor <- cor(data$"sulfate", data$"nitrate", use = "complete.obs")
      correlations = c(correlations, newCor)
    }
  }
  correlations
}
