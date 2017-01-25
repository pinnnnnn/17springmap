#Install required packages ----
if(!require(shinydashboard)) 
  install.packages("shinydashboard")
if(!require(leaflet)) 
  install.packages("leaflet")
if(!require(maptools)) 
  install.packages('maptools')
#if(!require(classInt)) 
# install.packages('classInt')
if(!require(RColorBrewer)) 
  install.packages('RColorBrewer')


#library(classInt)
library(shinydashboard)
library(RColorBrewer)
library(maptools) #for the function "readShapeSpatial"
library(sp)

#Load shapefile and data ----


NYC_PCT <- readShapeSpatial("/data/home/ogasawar17/graphics/MAP_16_Spring/Final/8. Visualization/New York/NYC_App/NYC_PCT_Shapefile_Selected/NYC_PCT_Shapefile_Selected")

NYC_SCH <- readShapeSpatial("/data/home/ogasawar17/graphics/MAP_16_Spring/Final/8. Visualization/New York/NYC_App/NYC_SCH_Shapefile_Selected/NYC_SCH_Shapefile_Selected")
