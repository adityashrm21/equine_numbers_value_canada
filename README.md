# Historical horse population in Canada
Shiny app that shows historical population of horses in Canada between 1906 and 1972.

App URL: https://ttimbers.shinyapps.io/equine_numbers_value_canada/

Horse population data were sourced from the [Government of Canada's Open Data website](http://open.canada.ca/en/open-data). Specifically, these two sources were used:
- [Horses, number on farms at June 1 and at December 1](http://open.canada.ca/data/en/dataset/43b3a9b3-3842-45e7-8bc8-c4c27b9462ab)
- [Horses, number on farms at June 1, farm value per head and total farm value](http://open.canada.ca/data/en/dataset/b374f60b-9580-44dc-83f6-c0a850c15f30)

Map data was sourced from [mapstarter.com](http://mapstarter.com/).

Dependencies:
- R and R packages:
  - shiny
  - tidyverse
  - leaflet
  - geojsonio
