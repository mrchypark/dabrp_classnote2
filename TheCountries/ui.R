#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(gridExtra)
library(dplyr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("checkGroup", label = h3("Choose a Country"), 
                         choices = list("Korea" = "Korea, Rep.", "USA" = "United States", "Canada" = "Canada", "China" = "China", "UK" = "United Kingdom", "Japan" = "Japan", "Rwanda" = "Rwanda", "Mexico" = "Mexico", "Ukraine" = "Ukraine", "Cambodia" = "Cambodia" ),
                         selected = "Korea")),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("out1")
    )
  )
))
