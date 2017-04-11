# Original Application

shinyServer(function(input, output) {
  
  nyc_pct <- reactive({
    NYC_PCT
  })

  nyc_pct_filtered <- reactive({
    nyc_pct()[-c(13), ]
  })  
  
  nyc_sch <- reactive({
    NYC_SCH
  })
  
  nyc_sch_dist <- reactive({
    NYC_SCH_DIST
  })
  
  nyc_tract <- reactive({
    NYC_TRACT
  })
  
   nyc_sch_filtered <- reactive({
     nyc_sch()[!is.na(nyc_sch()$Total), ]
   }) 
  
  nyc_sch_by_district <- reactive({
    over(nyc_sch_dist(), nyc_sch_filtered()[4:14], fn=sum, na.rm=TRUE)
  })
  
  
  #    Render base map ----

# Applciation on Left Side
  output$nycMap1 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(-74.004, 40.705, zoom = 9) %>%
      setMaxBounds(-73.000, 40.200, -75.000, 41.100)
  })

  # Application in the middle
  output$nycMap3 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(-74.004, 40.705, zoom = 9) %>%
      setMaxBounds(-73.000, 40.200, -75.000, 41.100)
  })
  
  

# Application on Right Side
  output$nycMap2 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(-74.004, 40.705, zoom = 9) %>%
      setMaxBounds(-73.000, 40.200, -75.000, 41.100)
  })
 
  
# Application on Left Side  
  # Create a color palette based on the chosen input for NYC crime data
  precinct_val1 <- reactive({
    nyc_pct_filtered()[[input$colorby1]]
  })
  
  
  precinct_val2 <- reactive({
    if(input$colorby2=="None"){rep(1, 76)}
    else if (input$colorby2 =="Popultn"){nyc_pct_filtered()$Population}
  })
  
  precinct_val <- reactive({
    precinct_linearval1 <- precinct_val1()/precinct_val2()
    if( input$scale1 == 'Logarithmic') { log(precinct_linearval1+0.00001)
    } else { precinct_linearval1 }
  })
  
#Application in the Middle
  # Create a color palette based on the chosen input for NYC census data
  tract_val1 <- reactive({
    nyc_tract()[[input$colorby5]]
  })
  
  tract_val2 <- reactive({
    if(input$colorby6=="None"){rep(1, 1335)}
    else if (input$colorby6 =="Population"){nyc_tract()$Population}
  })
  
  tract_val <- reactive({
    tract_linearval <- tract_val1()/tract_val2()
    if( input$scale3 == 'Logarithmic') { log(tract_linearval+0.00001)
    } else { tract_linearval }
  })

# Application on Right Side  
sch_val1 <- reactive({
  nyc_sch_filtered()[[input$colorby3]]
})


sch_val2 <- reactive({
  if(input$colorby4=="None"){rep(1, 1598)}
  else if (input$colorby4 =="Total"){nyc_sch_filtered()$Total}
  else if (input$colorby4 =="Num_Sch"){nyc_sch_filtered()$counts}
})

sch_val <- reactive({
  sch_linearval <- sch_val1()/sch_val2()
  if( input$scale2 == 'Logarithmic') { log(sch_linearval+0.00001)
  } else { sch_linearval }
})

sch_dist_val1 <- reactive({
  nyc_sch_by_district()[[input$colorby3]]
})


sch_dist_val2 <- reactive({
  if(input$colorby4=="None"){rep(1, 33)}
  else if (input$colorby4 =="Total"){nyc_sch_by_district()$Total}
  else if (input$colorby4 =="Num_Sch"){nyc_sch_by_district()$counts}
})

sch_dist_val <- reactive({
  sch_pct_linearval <- sch_dist_val1()/sch_dist_val2()
  if( input$scale2 == 'Logarithmic') { log(sch_pct_linearval+0.00001)
  } else { sch_pct_linearval }
})

# Both Applications
getColor_pct <- function(values){
  lower <- min(values, na.rm=TRUE)
  upper <- max(values, na.rm=TRUE)
  mapPalette1 <<- colorNumeric(c("#ffff00", "#ff0000"), c(lower, upper), 10)
  mapPalette1(values)
}

getColor_sch <- function(values){
    lower <- min(values, na.rm=TRUE)
    upper <- max(values, na.rm=TRUE)
    mapPalette2 <<- colorNumeric(c("#00FFFF", "#0000FF"), c(lower, upper), 10)
    mapPalette2(values)
  }


# Application on Left Side
  observe({
    pct_popup1 <- 
      paste0("Precinct ", nyc_pct_filtered()$Precinct,
             "<br><strong><center>", round(precinct_val(), digits=3) , "</strong>")
    leafletProxy("nycMap1") %>%
      clearControls() %>%
      clearShapes()
    
    leafletProxy("nycMap1") %>%
      addTiles() %>% 
      addPolygons(data=nyc_pct_filtered(),
                  layerId = ~Precinct,
                  fillColor = getColor_pct(precinct_val()), 
                  weight = 2, fillOpacity = .6,
                  popup = pct_popup1) %>%
      addLegend(position = "bottomright",
                title = "NYC Precincts",
                pal = mapPalette1, values = precinct_val())

  })
  
  # Application in the Middle
  observe({
    tract_popup <- 
      paste0("Tract ", nyc_tract()$TRACT,
             "<br><strong><center>", round(tract_val(), digits=3) , "</strong>")
    
    if(input$boundary=='Precinct'){ 
      leafletProxy("nycMap3") %>%
        clearControls() %>%
        clearShapes()
      
    leafletProxy("nycMap3") %>%
      addTiles() %>% 
      addPolygons(data=nyc_pct_filtered(),
                  layerId = ~Precinct,
                  fillColor = NA,
                  fillOpacity = 0,
                  weight = 2) %>%
      addPolygons(data=nyc_tract(),
                  layerId = ~TRACT,
                  fillColor = getColor_pct(tract_val()), 
                  weight = 2, fillOpacity = .6,
                  popup = tract_popup,
                  col=NA) %>%
      addLegend(position = "bottomright",
                title = "NYC Census Tract",
                pal = mapPalette1, values = tract_val())}
    
    else if (input$boundary=='District'){
      leafletProxy("nycMap3") %>%
        clearControls() %>%
        clearShapes()
      
      leafletProxy("nycMap3") %>%
        addTiles() %>% 
        addPolygons(data=nyc_sch_dist(),
                    layerId = ~school_dis,
                    fillColor = NA,
                    fillOpacity = 0,
                    weight = 2) %>%
        addPolygons(data=nyc_tract(),
                    layerId = ~TRACT,
                    fillColor = getColor_pct(tract_val()), 
                    weight = 2, fillOpacity = .6,
                    popup = tract_popup,
                    col=NA) %>%
        addLegend(position = "bottomright",
                  title = "NYC Census Tract",
                  pal = mapPalette1, values = tract_val())
    }
    else{
      leafletProxy("nycMap3") %>%
        clearControls() %>%
        clearShapes()
      
      leafletProxy("nycMap3") %>%
        addTiles() %>% 
        addPolygons(data=nyc_tract(),
                    layerId = ~TRACT,
                    fillColor = getColor_pct(tract_val()), 
                    weight = 2, fillOpacity = .6,
                    popup = tract_popup,
                    col=NA) %>%
        addLegend(position = "bottomright",
                  title = "NYC Census Tract",
                  pal = mapPalette1, values = tract_val())
    }
    
  })


# Application on Right Side
observe({
  sch_popup <- 
    paste0("<center>DBN: ", nyc_sch()$DBN,
           "<br>", nyc_sch()$School,
           "<br><center>", nyc_sch()$SchoolType,
           "<br><strong><center>", round(sch_val(), digits=3) , "</strong>")
  dist_popup <- 
    paste0("District ", nyc_sch_dist()$school_dis,
           "<br><strong><center>", round(sch_dist_val(), digits=3) , "</strong>")
  if(input$school=='School'){
  leafletProxy("nycMap2") %>%
    clearControls() %>%
    clearShapes()
  
  leafletProxy("nycMap2") %>%
    addTiles() %>% 
    addPolygons(data=nyc_sch_dist(),
                layerId = ~school_dis,
                fillColor = "yellow", 
                weight = 2, fillOpacity = .6) %>%
    addCircleMarkers(data=nyc_sch(),
                     layerId = ~DBN,
                     radius=1.5, col= getColor_sch(sch_val()),
                     opacity=.6,
                     popup = sch_popup) %>%
  addLegend(position = "bottomright",
            title = "NYC Schools",
            pal = mapPalette2, values = sch_val())}
  else {
    leafletProxy("nycMap2") %>%
      clearControls() %>%
      clearShapes()%>%
      clearMarkers()
    
    leafletProxy("nycMap2") %>%
      addTiles() %>% 
      addPolygons(data=nyc_sch_dist(),
                  layerId = ~school_dis,
                  fillColor = getColor_pct(sch_dist_val()), 
                  weight = 2, fillOpacity = .6,
                  popup=dist_popup) %>%
      addLegend(position = "bottomright",
                title = "By Precinct",
                pal = mapPalette1, values = sch_dist_val())
  }
})
  
  
})