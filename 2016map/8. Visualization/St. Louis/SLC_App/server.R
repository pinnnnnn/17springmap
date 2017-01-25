shinyServer(function(input, output) {
  
  sl_nhd <- reactive({
    SL_NHD
  })
  sl_nhd_info_arrest <- reactive({
    sl_nhd()@data
  })
  sl_sch <- reactive({
    SL_SCH
  })
  sl_sch_info <- reactive({
    sl_sch()@data
  })
  
  #    Render St. Louis City base map ----
  output$slMap1 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      #setView(-14.2 , 8.18, zoom = 12) %>%
      setView(-90.2, 38.63, zoom = 11) %>%
      #setMaxBounds(-14.00, 8.00, -15.00, 9.00)
      setMaxBounds(-89.198, 37, -91.198, 39)
  })
  
#   
#   #    SLC Mouseover events: highlights neighborhood and prints information
#   observe({
#     sl_event_click <- input$slMap1_shape_click
#     
#     if(!is.numeric(sl_event_click$id)) {
#       return()
#     }
#     
#     #         Neighborhood information:
#     sl_nhd_click <- sl_nhd()[sl_nhd()$NHD_NUM==sl_event_click$id,]
#     
#     
#     #         Highlights precinct:
#     leafletProxy("slMap1") %>%
#       addPolygons(data=sl_nhd_click, 
#                   layerId='highlighted', 
#                   color="white", fill = FALSE)
#   })
  
  
  
  # We don't want the "Popultn" column to have NA. 
  #In fact, those are the city parks where people do not live. 
  sl_nhd_filtered <- reactive({
    sl_nhd()[!is.na(sl_nhd()$Popultn), ]
  })
  
  
  # Create a color palette based on the chosen input
  nhd_val1 <- reactive({
    sl_nhd_filtered()[[input$colorby1]]
  })
  
  nhd_val2 <- reactive({
    if(input$colorby2=="None"){rep(1, 79)}
    else if (input$colorby2 =="Popultn"){sl_nhd_filtered()$Popultn}
  })
  
  nhd_val <- reactive({
    nhd_linearval <- nhd_val1()/nhd_val2()
    if( input$scale == 'Logarithmic') { log(nhd_linearval+0.00001)
    } else { nhd_linearval }
  })
  
  getColor <- function(values){
    lower <- min(values, na.rm=TRUE)
    upper <- max(values, na.rm=TRUE)
    mapPalette <<- colorNumeric(c("#ffff00", "#ff0000"), c(lower, upper), 10)
    mapPalette(values)
  }
  
  # We don't want the "Popultn" column to have NA. 
  #In fact, those are the city parks where people do not live. 
  sl_sch_filtered <- reactive({
    sl_sch()[!is.na(sl_sch()$TotalStu), ]
  })
  
  sch_val1 <- reactive({
    sl_sch_filtered()[[input$colorby3]]
  })
  
  sch_val2 <- reactive({
    if(input$colorby4=="None"){rep(1, 75)}
    else if (input$colorby4 =="TotalStu"){sl_sch_filtered()$TotalStu}
  })
  
  sch_val <- reactive({
    sch_linearval <- sch_val1()/sch_val2()
    if( input$scale == 'Logarithmic') { log(sch_linearval+0.00001)
    } else { sch_linearval }  
  })
   
  getColor1 <- function(values){
    lower <- min(values, na.rm=TRUE)
    upper <- max(values, na.rm=TRUE)
    mapPalette <<- colorNumeric(c("#14DEFF", "#0420E7"), c(lower, upper), 10)
    mapPalette(values)
  }
  
    
  
  observe({
    nhd_popup <- 
      #paste0(sl_nhd()$NHD_NUM, ". ", sl_nhd()$NHD_NAME,
             #"<br><strong><center>", nhd_val(), "</strong>")
    sch_popup <- 
      paste0(sl_sch()$Facility,
             "<br><strong><center>", round(sch_val(), digits=5) , "</strong>")
    
    leafletProxy("slMap1") %>%
      clearControls() %>%
      clearShapes()
    leafletProxy("slMap1") %>%
      addTiles() %>% 
      addPolygons(data=sl_nhd(),
                  layerId = ~NHD_NUM,
                  fillColor = getColor(nhd_val()), 
                  weight = 2, fillOpacity = .6,
                  popup = nhd_popup) %>%
    addLegend(position = "bottomright",
              title = "NHD",
              pal = mapPalette, values = nhd_val()) %>%
      addCircleMarkers(data=sl_sch(),
                       layerId = ~SchNum,
                       radius=3, col= getColor1(sch_val()),
                       opacity=.6,
                       popup = sch_popup) %>%
      addLegend(position = "bottomright",
                title = "SCH",
                pal = mapPalette, values = sch_val())
  })
  
   
})