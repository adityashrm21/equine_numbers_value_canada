
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(tidyverse)
library(leaflet)
library(rgdal)

canada <- readOGR("data/CanadianProvinces.kml",
                  "CanadianProvinces3",
                  encoding="utf-8")

shinyServer(function(input, output) {
  
  output$horse_pop_Plot <- renderPlot({

    # generate bins based on input$bins from ui.R
    horse_pop <- read_csv("data/00030067-eng.csv")
    horse_pop <- filter(horse_pop,
                        DATE == "At June 1 (x 1,000)")
    horse_pop$Value <- horse_pop$Value * 1000
    
    # get region of interest from input
    region <- input$region

    # draw the line plot for the specified region
    horse_pop_region <- filter(horse_pop,
                               GEO == region)
    ggplot(horse_pop_region, aes(x = Ref_Date, y = Value)) +
      geom_point() +
      geom_line() +
      xlab("Year") +
      ylab("Number of horses") +
      ggtitle(region)

  })
  
  output$horse_pop_map <- renderLeaflet({
    horse_pop <- read_csv("data/00030067-eng.csv")
    horse_pop <- filter(horse_pop,
                        DATE == "At June 1 (x 1,000)")
    horse_pop$Value <- horse_pop$Value * 1000

    # get year of interest from input
    year <- input$year

    #load base map
    # canada <- readOGR("data/CanadianProvinces.kml",
    #                   "CanadianProvinces3",
    #                   encoding="utf-8")

    # draw map for that year
    horse_pop_year <- filter(horse_pop,
                             Ref_Date == year,
                             GEO != "Canada")

    pal <- colorQuantile("YlGn", NULL, n = 5)

    prov_popup <- paste0("<strong>Province: </strong>",
                         horse_pop_year$GEO,
                          "<br><strong>Number of horses: </strong>",
                         horse_pop_year$Value)

    leaflet(data = canada) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(fillColor = ~pal(horse_pop_year$Value),
                  fillOpacity = 0.8,
                  color = "#BDBDC3",
                  weight = 1,
                  popup = prov_popup)

  })

})
