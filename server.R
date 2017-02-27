# server logics code for equine_numbers_value_canada shiny app
# author: Tiffany A. Timbers
# created: Feb 27, 2017

library(shiny)
library(tidyverse)
library(leaflet)
library(geojsonio)

# load data
canada <- geojsonio::geojson_read("data/canada.geojson", what = "sp")

horse_pop <- read_csv("data/00030067-eng.csv")
horse_pop <- filter(horse_pop,
                    DATE == "At June 1 (x 1,000)")
horse_pop$Value <- horse_pop$Value * 1000

# create plot & map outputs that change based on user inputs
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
    canada_year <- merge(canada, horse_pop_year, by.x = "NAME", by.y = "GEO")
    
    #create colour pallete for chloropleth map
    pal <- colorNumeric("YlGn", NULL, n = 5)

    # create pop_up data
    prov_popup <- paste0("<strong>Province: </strong>",
                         canada_year$NAME,
                          "<br><strong>Number of horses: </strong>",
                         canada_year$Value)

    # create map
    leaflet(data = canada_year) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lat = 62, lng = -105, zoom = 3) %>% 
      addPolygons(fillColor = ~pal(Value),
                  fillOpacity = 0.8,
                  color = "#BDBDC3",
                  weight = 1,
                  popup = prov_popup) %>%
      addLegend(pal = pal, 
                values = ~ Value,  
                opacity = 0.7, 
                title = paste0("Number of horses (",  input$year, ")"),
                position = "topright")

  })
})
