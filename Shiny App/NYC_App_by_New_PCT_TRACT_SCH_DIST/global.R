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


NYC_PCT <- readShapeSpatial("/data/home/ogasawar17/MAP_17_Spring/NYC_App_by_New_PCT_TRACT_SCH_DIST/NYPD_PCT_Shapefile_Arrest_2015/NYPD_PCT_Shapefile_Arrest_2015")

NYC_SCH <- readShapeSpatial("/data/home/ogasawar17/MAP_17_Spring/NYC_App_by_New_PCT_TRACT_SCH_DIST/NYC_SCH_Shapefile_Selected/NYC_SCH_Shapefile_Selected")

NYC_SCH_DIST <- readShapeSpatial("/data/home/ogasawar17/MAP_17_Spring/NYC_App_by_New_PCT_TRACT_SCH_DIST/NYC_School_District/NYC_School_District_Shapefile")

NYC_TRACT <- readShapeSpatial("/data/home/ogasawar17/MAP_17_Spring/NYC_App_by_New_PCT_TRACT_SCH_DIST/NYC_Census_Tract_Shapefile_Attribute/NYC_Census_Tract_Shapefile_Attribute")
