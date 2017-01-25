require(shinydashboard)
require(leaflet)

shinyUI(dashboardPage(
  dashboardHeader(title = "NYC Census Data by Police Precinct"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$head(tags$style(HTML('
                              
                              /* Sidebar font size */
                              .sidebar-menu>li>a {
                              font-size:16px;
                              }
                              /* Box title font size */
                              .box-header .box-title, .box-header>.fa, .box-header>.glyphicon, .box-header>.ion {
                              font-size: 20px;
                              }
                              /* Expand and center title */
                              .main-header .logo {
                              float:inherit;
                              width:inherit;
                              }
                              .main-header .navbar {
                              display: none;
                              }
                              
                              '))),
    title = "Precinct", skin="blue",
    
    fluidPage(fluidRow(
      column(6,
             box(title = "Map of New York City Precinct", solidHeader=T, status="primary", width = '100%',
                 top=10, right = 10,
                 div(style = 'display: flex',
                     div(style='flex: 1.5',
                       selectInput("colorby1","Color Precinct by:",choices=c(
                         "Population" = "Popultn",
                         "White" = "White",
                         "Black" = "Black",
                         "Hispanic" = "Hispnc",
                         "Unemployment Rate" = "UnplyR",
                         "Poverty Unemployment Rate" = "PvUnplyR",
                         "Total Arrest" = "Arrest15",
                         "Total Frisk" = "Frisk15",
                         "Total Search" = "Search15",
                         "Average Age of Arrest" = "Age15",
                         "Black Arrest" = "Black15",
                         "White Arrest" = "White15",
                         "Homicide" = "Homici15",
                         "Assault" = "Asslt15"))),
                 div(style='flex: 1.5',
                     selectInput("colorby2","Divided by:",choices=c(
                       "None" = "None",
                       "Population" = "Popultn")))),
                 div(style='display: block', 
                     radioButtons('scale1', "Scale", 
                                  choices = c('Linear', 'Logarithmic'), inline=TRUE)),
                 div(leafletOutput("nycMap1", height = 400)),
                 div(htmlOutput("footer1"), align = "right")
             )),
      column(6,
             box(title = "Map of New York City Schools", solidHeader=T, status="primary", width = '100%',
                 top=10, right = 10,
                 div(style = 'display: flex',
                     div(style='flex: 1.5',
                         selectInput("colorby3","Color School by:",choices=c(
                           "Total Students" = "Total",
                           "White" = "White",
                           "Black" = "Black",
                           "Free Reduced Lunch" = "Poverty",
                           "ELA Mean" = "MSELA",
                           "ELA Level3&4" = "L34NmELA",
                           "Math Mean" = "MSMAT",
                           "Math Level3&4" = "L34NmMAT",
                           "Total Grads" = "TtlGrad4",
                           "Dropout" = "DropOut4"))),
                     div(style='flex: 1.5',
                         selectInput("colorby4","Divided by:",choices=c(
                           "None" = "None",
                            "Total Students" = "Total",
                           "Number of Schools" = "Num_Sch")))),
                 div(style='display: flex', 
                     div(style='flex: 1.5',
                     radioButtons('scale2', "Scale", 
                                  choices = c('Linear', 'Logarithmic'), inline=TRUE)),
                     div(style='flex:1.5',
                         radioButtons('school', "Statistics by", 
                                      choices = c('School', 'Precinct'), inline=TRUE))),
                 
                 div(leafletOutput("nycMap2", height = 400)),
                 div(htmlOutput("footer2"), align = "right")
             ))
      
    ))
    )
    )
    )