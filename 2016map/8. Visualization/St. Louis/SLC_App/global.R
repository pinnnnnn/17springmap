#Install required packages ----
if(!require(shinydashboard)) install.packages("shinydashboard")
if(!require(leaflet)) install.packages("leaflet")
if(!require(maptools)) install.packages('maptools')
#if(!require(classInt)) install.packages('classInt')
if(!require(RColorBrewer)) install.packages('RColorBrewer')

#library(classInt)
library(shinydashboard)
library(RColorBrewer)
library(maptools) #for the function "readShapeSpatial"

#Load shapefile and data ----


if(!exists("SL_NHD")) SL_NHD <- 
  readShapeSpatial("/data/home/ogasawar17/graphics/MAP_16_Spring/Final/8. Visualization/St. Louis/SLC_App/SL_NHD_Shapefile_Selected/SL_NHD_Shapefile_Selected")

if(!exists("SL_SCH")) SL_SCH <- 
  readShapeSpatial("/data/home/ogasawar17/graphics/MAP_16_Spring/Final/8. Visualization/St. Louis/SLC_App/SL_SCH_Shapefile_Selected/SL_SCH_Shapefile_Selected")


