library(shiny)
library(shinyWidgets)
library(shinydashboard)

library(dplyr)

# Define UI
ui <- dashboardPage(
    
    dashboardHeader(
        title = "Shiny Training"
    ),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("Table", tabName = "table", icon = icon("table"))
        ),
        
        checkboxGroupInput("pos", label = "Pos",
                           choices = c('QB', 'RB', 'WR', 'TE', 'DST', 'K'))
    ),
    
    dashboardBody(
        tabItems(
            tabItem(tabName = "table",
                    h2("Here is my table."),
                    tableOutput('rkgs')
            )
        )
    )
)


# Define server
server <- function(input, output) {
    
    rk <- read.csv('~/Shiny_Work/shiny-training/rk.csv')
    
    output$rkgs <- renderTable({
        
        if (length(input$pos) > 0) {
            rk %>% filter(Pos %in% input$pos)
        } else {
            rk
        }
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
