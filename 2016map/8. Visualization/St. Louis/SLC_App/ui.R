require(shinydashboard)
require(leaflet)

shinyUI(dashboardPage(
  dashboardHeader(title = "School and Crime Data in St. Louis"),
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
    title = "St. Louis Neighborhood", skin="blue",
    
    fluidPage(fluidRow(
      column(6,
             box(title = "Map of St. Louis NHD", solidHeader=T, status="primary", width = '100%',
                 
                 top=10, right = 10,
                 div(style = 'display: flex',
                     div(style='flex: 1.5',
                         selectInput("colorby1","Color NHD by:",choices=c(
                           "Population" = "Popultn",
                           "White" = "White",
                           "Black" = "Black",
                           "Total Arrests" = "Ttl_Crm",
                           "Homicide" = "Homicid",
                           "Assault" = "Assault",
                           "Unemployment Rate" = "EnmplRt",
                           "Income Per Capita" = "IncPrCp"))),
                     div(style='flex: 1.5',
                         selectInput("colorby2","Divided by:",choices=c(
                           "None" = "None",
                           "Population" = "Popultn")))),
                 div(style = 'display: flex',
                     div(style='flex: 1.5',
                         selectInput("colorby3","Color SCH by:",choices=c(
                           "Total Students" = "TotalStu",
                           "Black" = "BlackStu",
                           "White" = "WhiteStu",
                           "Total Incidents" = "TtlIncd",
                           "Eng Mean Score" = "EngMS",
                           "Mat Mean Score" = "MatMS",
                           "Number of Graduation" = "GradNum",
                           "ACT Score" = "ACTScor"))),
                     div(style='flex: 1.5',
                         selectInput("colorby4","Divided by:",choices=c(
                           "None" = "None",
                           "Total Students" = "TotalStu")))),
                 div(style='display: block', 
                     radioButtons('scale', "Scale", 
                                  choices = c('Linear', 'Logarithmic'), inline=TRUE)),
                 div(leafletOutput("slMap1", height = 400)),
                 div(htmlOutput("footer1"), align = "right"),
                 div(p("For more information, visit the ",
                       a("Stat2lab homepage", 
                         href = "http://web.grinnell.edu/individuals/kuipers/stat2labs/Labs.html")))
             ))
      
    ))
  )
)
)
