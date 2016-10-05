library(shiny)
library(slam)
library(Matrix)

#object visible across all sessions, containing my ngram frequencies
load('singleWordsInfo.rda')
load('sparseMatrices.rda')

#source the required functions
source('../cleanInput.R')         #Preprocess the input text and return a vector of three words
source('../predictNextWord.R')    #Perform text prediction
source('../predictWithTrigram.R') #Backoff
source('../predictWithBigram.R')  #Backoff
source('../createHtmlButtons.R')  #Create the output buttons

# Define server logic required to print the output
shinyServer(function(input, output) {
  # Call the function predictText to get a list of predicted words 
  
  output$predictions <- renderUI({
    #preprocess input    
    cleanedInput <- cleanInput(input$textIn)
    #predict text
    #predictions <- predictText(cleanedInput)
    #create output
    HTML(createHtmlButtons(cleanedInput))
  })
})
