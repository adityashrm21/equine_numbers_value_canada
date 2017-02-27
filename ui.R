
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)
library(tidyverse)

# get possible regions
horse_pop <- read_csv("data/00030067-eng.csv")
possible_regions <- unique(horse_pop$GEO)

shinyUI(fluidPage(

  # Application title
  titlePanel("Historical horse population data from Canada \n (1914 - 1972)"),
  
  # # add panel that contains slider & drop down menu, as well as line plot
  # absolutePanel(top = 60, left = "auto", right = 20, bottom = "auto",
  #               width = 330, height = "auto",
  #               
  #               selectInput(inputId = "region",
  #                           label = "Number of bins:",
  #                           choices = possible_regions),
  #               
  #               sliderInput(inputId = "year",
  #                           label = "Year:",
  #                           min = 1906,
  #                           max = 1972,
  #                           value = 1906,
  #                           sep = ""),
  #               
  #               plotOutput("horse_pop_Plot")
  # )
  
  # Sidebar with a slider input for number of bins
   sidebarLayout(
     sidebarPanel(
       selectInput(inputId = "region",
                  label = "Number of bins:",
                  choices = possible_regions),

      plotOutput("horse_pop_Plot")
    ),
    
    
    # put map in main panel entire background
    mainPanel(
      leafletOutput("horse_pop_map"),
      
      sliderInput(inputId = "year",
                  label = "Year:",
                  min = 1906,
                  max = 1972,
                  value = 1906,
                  sep = "", 
                  width='100%')
      )

  )
  )
)
