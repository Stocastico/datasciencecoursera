library('e1071')
library(ggplot2)
library(shiny)
data( iris )

getParams <- function( cost, kernel ) {
  resNum <- as.numeric(cost)
  resStr <- as.character(kernel)
  res <- list(resNum, resStr)
  names(res) <- c("Cost", "Kernel")
  res
}

doModeling <- function( cost, kernel ) {
  model <- svm( iris$Species~., iris, kernel = kernel, cost = cost )
  res <- predict( model, newdata=iris )
  good <- iris$Species == res
  q <- qplot(Petal.Width, Petal.Length, data = iris, color = good)
  acc <- sum(good) / length(good)
  res <- list(q, acc)
  names(res) <- c("Plot", "Accuracy")
  res
}

shinyServer( function(input, output) {
  x <- reactive({getParams(input$idC, input$idKernel)})
  output$oidC <- renderText({x()$Cost                       })
  output$oidKernel <- renderText({x()$Kernel})
  output$oAccuracy <- renderText({
    if (input$go > 0) {
      y <- isolate(doModeling(input$idC, input$idKernel))
      y$Accuracy
    }
  })
  output$resPlot <- renderPlot({
    if (input$go > 0) {
      y <- isolate(doModeling(input$idC, input$idKernel))
      y$Plot
    }
  })
})
