library(shiny)

htmlTemplate("template.html",
             textIn = textInput("text", "Insert your text:", width = '100%',
                                 placeholder = "Add text here")
)
