#Install required packages ----
if(!require(shinydashboard)) 
  install.packages("shinydashboard")
if(!require(leaflet)) 
  install.packages("leaflet")
if(!require(maptools)) 
  install.packages('maptools')


library(shinydashboard)
library(maptools) #for the function "readShapeSpatial"
library(sp)

#Load shapefile and data ----


NYC_SCH_DIST <- readShapeSpatial("/data/home/ogasawar17/MAP_17_Spring/NYC_App_by_SCH_DIST/NYC_School_District/NYC_School_District_Shapefile")
