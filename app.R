
setwd('C:/Users/jimmy/OneDrive/Documents/NBA')
source("source_data.R")

ui <- 
  
navbarPage('NBA projections',
           tabPanel('Bubble',
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('xaxis',
                                    'Choose x variable',
                                    choices = colnames(projs[7:15])),
                        selectInput('yaxis',
                                   'choose y variable',
                                   choices = colnames(projs[7:15])),
                        selectInput('bubblesize',
                                    choices = colnames(projs[7:15]))),
                      mainPanel(
                        plotlyOutput('bubble')
                      ))),
                      tabPanel('Table',
                                 mainPanel(
                                   dataTableOutput('table')
                                 )
                      
                    ))



server <- function(input, output, session) {

  
}

shinyApp(ui, server)


