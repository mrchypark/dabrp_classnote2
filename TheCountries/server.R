#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(gapminder)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #datac <- reactive({gapminder %>% filter(country %in% input$checkGroup)})
   
  output$out1 <- renderPlot({
    gapminder %>% filter(country %in% input$checkGroup) %>%
      ggplot(aes(x = year, y = lifeExp, color = country)) +
      geom_line() + geom_point()
    
    
    
  })
  
})
