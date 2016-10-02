createHtmlButtons <- function(text) {
  btns = ''
  for (k in 1:length(text)) {
    btns <- paste(btns, ' <button disabled>', text[k], ' </button>')
  }
  return(btns)
}