library(shiny)
library(slam)

#source the required functions
source('./cleanInput.R')         #Preprocess the input text and return a vector of three words
source('./predictNextWord.R')    #Perform text prediction
source('./predictWithTrigram.R') #Backoff
source('./predictWithBigram.R')  #Backoff
source('./createHtmlButtons.R')  #Create the output buttons

# Define server logic required to print the output
shinyServer(function(input, output) {

  output$predictions <- renderUI({
    cleanedInput <- eventReactive(input$text, {
      cleanInput(input$text)
    })

    #preprocess input
    #cleanedInput <- cleanInput(as.character(text))
    #predict text
    pred <- predictNextWord(cleanedInput(), myDict, quadgram_sparse, trigram_sparse, bigram_sparse, 5)
    #create output
    HTML(createHtmlButtons(pred))
  })
})


