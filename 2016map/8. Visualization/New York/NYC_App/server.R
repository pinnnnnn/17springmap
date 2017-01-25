# Original Application

shinyServer(function(input, output) {
  
  nyc_pct <- reactive({
    NYC_PCT
  })

  nyc_pct_filtered <- reactive({
    nyc_pct()[!is.na(nyc_pct()$Popultn), ]
  })  
  
  nyc_sch <- reactive({
    NYC_SCH
  })
  
   nyc_sch_filtered <- reactive({
     nyc_sch()[!is.na(nyc_sch()$Total), ]
   }) 
  
  nyc_sch_by_precinct <- reactive({
    over(nyc_pct_filtered(), nyc_sch_filtered()[4:14], fn=sum, na.rm=TRUE)
  })
  
  
  #    Render base map ----

# Applciation on Left Side
  output$nycMap1 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(-74.004, 40.705, zoom = 10) %>%
      setMaxBounds(-73.000, 40.200, -75.000, 41.100)
  })

# Application on Right Side
  output$nycMap2 <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(-74.004, 40.705, zoom = 10) %>%
      setMaxBounds(-73.000, 40.200, -75.000, 41.100)
  })
 
  
# Application on Left Side  
  # Create a color palette based on the chosen input for NYC census data
  precinct_val1 <- reactive({
    nyc_pct_filtered()[[input$colorby1]]
  })
  
  
  precinct_val2 <- reactive({
    if(input$colorby2=="None"){rep(1, 76)}
    else if (input$colorby2 =="Popultn"){nyc_pct_filtered()$Popultn}
  })
  
  precinct_val <- reactive({
    precinct_linearval <- precinct_val1()/precinct_val2()
    if( input$scale1 == 'Logarithmic') { log(precinct_linearval+0.00001)
    } else { precinct_linearval }
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

sch_pct_val1 <- reactive({
  nyc_sch_by_precinct()[[input$colorby3]]
})


sch_pct_val2 <- reactive({
  if(input$colorby4=="None"){rep(1, 1598)}
  else if (input$colorby4 =="Total"){nyc_sch_by_precinct()$Total}
  else if (input$colorby4 =="Num_Sch"){nyc_sch_by_precinct()$counts}
})

sch_pct_val <- reactive({
  sch_pct_linearval <- sch_pct_val1()/sch_pct_val2()
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
    pct_popup <- 
      paste0("Precinct ", nyc_pct()$Precinct,
             "<br><strong><center>", round(precinct_val(), digits=5) , "</strong>")
    leafletProxy("nycMap1") %>%
      clearControls() %>%
      clearShapes()
    
    leafletProxy("nycMap1") %>%
      addTiles() %>% 
      addPolygons(data=nyc_pct(),
                  layerId = ~Precinct,
                  fillColor = getColor_pct(precinct_val()), 
                  weight = 2, fillOpacity = .6,
                  popup = pct_popup) %>%
      addLegend(position = "bottomright",
                title = "NYC Precincts",
                pal = mapPalette1, values = precinct_val())

  })


# Application on Right Side
observe({
  sch_popup <- 
    paste0("<center>DBN: ", nyc_sch()$DBN,
           "<br>", nyc_sch()$School,
           "<br><center>", nyc_sch()$SchoolType,
           "<br><strong><center>", round(sch_val(), digits=5) , "</strong>")
  pct_popup <- 
    paste0("Precinct ", nyc_pct()$Precinct,
           "<br><strong><center>", round(sch_pct_val(), digits=5) , "</strong>")
  if(input$school=='School'){
  leafletProxy("nycMap2") %>%
    clearControls() %>%
    clearShapes()
  
  leafletProxy("nycMap2") %>%
    addTiles() %>% 
    addPolygons(data=nyc_pct(),
                layerId = ~Precinct,
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
      addPolygons(data=nyc_pct(),
                  layerId = ~Precinct,
                  fillColor = getColor_pct(sch_pct_val()), 
                  weight = 2, fillOpacity = .6,
                  popup=pct_popup) %>%
      addLegend(position = "bottomright",
                title = "By Precinct",
                pal = mapPalette1, values = sch_pct_val())
  }
})
  
  
})