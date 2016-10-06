library(shiny)

htmlTemplate("template.html",
             #button = actionButton("go", "Predict text"),
             textIn = textInput("text", "Insert your text:", width = '100%',
                                 placeholder = "Add text here")
)
