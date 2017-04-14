
require(shinydashboard)
require(leaflet)

shinyUI(dashboardPage(
  dashboardHeader(title = "NYC Map"),
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
    title = "School District", skin="blue",
    
    fluidPage(fluidRow(
      column(6,
             box(title = "Map of New York City", solidHeader=T, status="primary", width = '100%',
                 top=10, right = 10,
                 div(style = 'display: flex',
                     div(style='flex: 1.5',
                         selectInput("colorby1","Color School Districts by:",choices=c(
                           "Total Crime" = "TOTAL_CRIME")))),
                 div(leafletOutput("nycMap1", height = 400)),
                 div(htmlOutput("footer1"), align = "right")
             )),
      div(p("For more information, visit the ",
            a("Stat2lab Homepage", 
              href = "http://web.grinnell.edu/individuals/kuipers/stat2labs/Labs.html")))
      
    ))
    )
    )
    )