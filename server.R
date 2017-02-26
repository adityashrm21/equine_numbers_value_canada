
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(tidyverse)
library(leaflet)
library(rgdal)

# load data
canada <- readOGR("data/CanadianProvinces.kml",
                  "CanadianProvinces3",
                  encoding="utf-8")

horse_pop <- read_csv("data/00030067-eng.csv")
horse_pop <- filter(horse_pop,
                    DATE == "At June 1 (x 1,000)")
horse_pop$Value <- horse_pop$Value * 1000


shinyServer(function(input, output) {
  
  output$horse_pop_Plot <- renderPlot({

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
    # get year of interest from input
    year <- input$year

    #filter to desired year
    horse_pop_year <- filter(horse_pop,
                             Ref_Date == year,
                             GEO != "Canada") %>% 
      select(GEO, Value)

    # merge data with canada data
    canada_year <- merge(canada, horse_pop_year, by.x = "Name", by.y = "GEO")
    
    pal <- colorQuantile("YlGn", NULL, n = 5)

    # create pop_up data
    prov_popup <- paste0("<strong>Province: </strong>",
                         canada_year@data$Name,
                          "<br><strong>Number of horses: </strong>",
                         canada_year@data$Value)

    # create map
    leaflet(data = canada_year) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addPolygons(fillColor = ~pal(Value),
                  fillOpacity = 0.8,
                  color = "#BDBDC3",
                  weight = 1,
                  popup = prov_popup)

  })

})
