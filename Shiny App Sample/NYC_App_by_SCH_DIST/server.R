# Original Application

shinyServer(function(input, output) {
  
  nyc_sch_dist <- reactive({
    NYC_SCH_DIST
  })
  
  
  #    Render base map ----
  
  # Applciation on Left Side
  output$nycMap1 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(-74.004, 40.705, zoom = 9) %>%
      setMaxBounds(-73.000, 40.200, -75.000, 41.100)
  })
  

  
  # Application on Left Side
  observe({
    leafletProxy("nycMap1") %>%
      clearControls() %>%
      clearShapes()
    
    leafletProxy("nycMap1") %>%
      addTiles() %>% 
      addPolygons(data=nyc_sch_dist(),
                  layerId = ~school_dis,
                  fillOpacity = 0)
  })
  
  
})