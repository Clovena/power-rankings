library(shiny)
library(shinyWidgets)
library(shinydashboard)

library(dplyr)
library(lubridate)

library(nflfastR)

# A. Define UI -----
ui <- dashboardPage(
    
  ## 1. Dashboard Header -----
  dashboardHeader(
    ### a. Header Title -----
      title = "6 C D F L"
  ),
  
  ## 2. Dashboard Sidebar -----
  dashboardSidebar(
    sidebarMenu(
      id = 'tabs',
      menuItem("Home",           tabName = 'pg_index', icon = icon('house')),
      menuItem("About",          tabName = 'pg_about', icon = icon('magnifying-glass')),
      menuItem("Franchises",     tabName = 'pg_frchs', icon = icon('people-group')),
      menuItem("Schedule",       tabName = 'pg_sched', icon = icon('calendar')),
      menuItem("Standings",      tabName = 'pg_stand', icon = icon('list-ol')),
      menuItem("History",        tabName = 'pg_hstry', icon = icon('scroll')),
      menuItem("Power Rankings", tabName = 'pg_prkgs', icon = icon('ranking-star')),
      menuItem("Admin",          tabName = 'pg_admin', icon = icon('unlock'))
    )
  ),
  
  ## 3. Dashboard Body -----
  dashboardBody(
    
    ### a. CSS Styling -----
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    ### b. Body Elements-----
    tabItems(
      #### i. Home -----
      tabItem(tabName = 'pg_index',
              
              ##### α. Home Page Header
              h1("Sixth City Dynasty Football"),
              br(),
              tags$hr(style="border-color: gray;"),
              h3("Rugged Cleveland football in the Great White North."),
              br(),
              
              ##### β. League Description
              p("The Sixth City Dynasty Football League was founded in 2021 as a branch off of 
                 a standard redraft league with origins in the Sigma Phi Epsilon Ohio Zeta chapter.
                 Rooted in Cleveland, 6C is host to members throughout Ohio.
                 What began as a group of fraternity buddies coming together to enjoy the game of football
                 has now evolved into a large-scale dynasty league, complete with
                 a full history of rivalries, narratives, and statistics."),
              br(),
              
              ##### γ. Internal Links
              h4("For more information on the league,"),
              actionLink('link_about', "visit the About page."),
              h4("For a complete history of the league,"),
              actionLink('link_hstry', "visit the History page."),
              br(),
              tags$hr(style="border-color: gray;"),
              
              ##### δ. This Week's Games
              h2("This Week's Games"),
              textOutput('tw_sched_p'),
              h4("For a full season schedule,"),
              actionLink('link_sched', "visit the Schedule page."),
              tableOutput('tw_sched_tbl')
      ), # End Home
      
      #### ii. About -----
      tabItem(tabName = 'pg_about',
              
              ##### α. About Page Header
              h1("About the League"),
              br(),
              tags$hr(style="border-color: gray;"),
              
              ##### β. Franchises Description
              h2("Franchises"),
              p("Fourteen franchises across two conferences comprise Sixth City Dynasty.
                 Many organizations are based in Canada, but the league stretches down to the US
                 and across the globe to Australia."),
              p("Teams engage in a 14-week season, followed by three rounds of an eight-team playoff.
                The champions of each conference are awarded the top two seeds,
                followed by the next best three teams each."),
              p("Currently, each franchise plays each conference rival at least once; 
                two additional intra-conference games are scheduled to make eight total games. 
                The remaining six games are played against inter-conference teams on a rotating basis."),
              br(),
              
              ##### γ. Map of Franchises
              # renderImage('frchs_map'),
              # em("Map of franchises."),
              # br(),
              # tags$hr(style="border-color: gray;"),
              
              ##### δ. Conferences
              h2("Conferences"),
              HTML("Sixth City is divided into two conferences:
                 the <b>Senatorial Canadian Conference</b> and the <b>House of Commons Conference</b>."),
              # Senatorial Canadian Conference
              p("The SCC are the older and more prestigious conference.
                They pride themselves on their refined strategies,
                but opponents might say that their lackadaisical temperament
                has made them no longer representative of what their cities want in a football team."),
              # SCC Teams
              HTML("<ul>"),
              actionLink("link_gld", HTML("<li>Gold Coast Sharks")),
              actionLink("link_mtl", HTML("<li>Montreal Generals")),
              actionLink("link_nfd", HTML("<li>Newfoundland Blowers")),
              actionLink("link_ssk", HTML("<li>Saskatoon Squirrels")),
              actionLink("link_tby", HTML("<li>Thunder Bay Mustangs")),
              actionLink("link_tor", HTML("<li>Toronto Hogs")),
              actionLink("link_van", HTML("<li>Vancouver Mounties")),
              HTML("</ul>"),
              # House of Commons Conference
              p("The HCC prefer the everyman’s approach to football:
                hard-nosed, down and dirty blue collar football that the people love.
                However, some wonder whether or not they are willing to adapt
                to the way the game is changing."),
              # HCC Teams
              HTML("<ul>"),
              actionLink("link_bkb", HTML("<li>Bikini Bottom Stars")),
              actionLink("link_cgy", HTML("<li>Calgary Cocks")),
              actionLink("link_chc", HTML("<li>Choccolocco Railfans")),
              actionLink("link_iqt", HTML("<li>Iqaluit Trout")),
              actionLink("link_mis", HTML("<li>Mississauga Mastodons")),
              actionLink("link_pko", HTML("<li>Pokemon Omega Judge Judy")),
              actionLink("link_wpg", HTML("<li>Winnipeg Wranglers")),
              HTML("</ul>")
      ), # End About
      
      #### iii. Franchises -----
      tabItem(tabName = 'pg_frchs',
              h1("League Franchises")
      ), # End Franchises
      
      #### iv. Schedule -----
      tabItem(tabName = 'pg_sched',
              
              ##### α. Schedule Page Header
              h1("Season Schedule"),
              br(),
              tags$hr(style="border-color: gray;"),
              
              ##### β. Schedule Page Subheader
              textOutput('ts_sched_p'),
              h4("For historical scores,"),
              actionLink('link_hstry', "visit the History page."),
              
              ##### γ. Schedule Table
              # Dropdown to select week
              tableOutput('ts_sched_tbl')
              
      ), # End Schedule
      
      #### v. Standings -----
      tabItem(tabName = 'pg_stand',
              
              ##### α. Standings Page Header
              h1("Season Standings"),
              br(),
              tags$hr(style="border-color: gray;"),
              
              ##### β. Standings Page Subheader
              textOutput('ts_stand_p'),
              h4("For historical standings,"),
              actionLink('link_hstry', "visit the History page."),
              
              ##### γ. Standings Tables
              tableOutput('ts_stand_tbl_scc'),
              tableOutput('ts_stand_tbl_hcc')
              
      ), # End Standings
      
      #### vi. History -----
      tabItem(tabName = 'pg_hstry',
              h1("League History")
      ), # End History
      
      #### vii. Power Rankings -----
      tabItem(tabName = 'pg_prkgs',
              h1("Power Rankings")
      ), # End Power Rankings
      
      #### viii. League Admin -----
      tabItem(tabName = 'pg_admin',
              h1("Admin")
      ) # End Admin
      
    ) # End Sidebar tabs
    
  ), # End dashboard body
  
  ## 4. Dashboard Theme -----
  skin = 'red'
  
) # End UI


# B. Define server -----
server <- function(input, output, session) {
  
  ## 1. Define universal objects -----
  season = year(Sys.Date()-31)
  
  ## 2. Observe internal links -----
  observeEvent(input$link_about, {
    updateTabItems(session, 'tabs', 'pg_about')
  })
  observeEvent(input$link_hstry, {
    updateTabItems(session, 'tabs', 'pg_hstry')
  })
  observeEvent(input$link_sched, {
    updateTabItems(session, 'tabs', 'pg_sched')
  })
  ### Need franchise-wise observeEvents
  
  ### Need textOutput and tableOutput for Home page, Schedule page, Standings page

}

# C. Run the application  -----
shinyApp(ui = ui, server = server)
