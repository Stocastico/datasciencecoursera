splitTrainingTesting <- function(data, pctTrain) {
  totElem <- length(data)
  train_ind <- sample(seq_len(totElem), size = round(pctTrain * totElem))
  tr <- data[train_ind]
  te <- data[-train_ind]
  dataSplit <- list(train = tr, test = te)
  return(dataSplit)
}