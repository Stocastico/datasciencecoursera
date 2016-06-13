shinyUI(pageWithSidebar(
  headerPanel("Choosing SVM Parameters"),
  sidebarPanel(
    numericInput('idC', 'Choose cost factor', 1, min = 1, max = 10, step = 1),
    radioButtons("idKernel", "Radio",
                       c("linear" = "linear",
                         "polynomial" = "polynomial",
                         "radial" = "radial"), selected = "linear"),
    actionButton("go", "Classify!", width = '100%')
  ),
  mainPanel(
    mainPanel(
      h3('Results of classification'),
      h4('Cost factor chosen'),
      verbatimTextOutput("oidC"),
      h4('Kernel function chosen'),
      verbatimTextOutput("oidKernel"),
      h4('Accuracy of classification:'),
      verbatimTextOutput("oAccuracy"),
      plotOutput('resPlot')
    )
    
  ) ))