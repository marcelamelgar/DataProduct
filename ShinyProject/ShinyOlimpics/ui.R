
library(shiny)
library(shinythemes)
library(markdown)
library(lubridate)

shinyUI(fluidPage(theme = shinytheme("sandstone"),

    navbarPage("Juegos Olimpicos",
               tabPanel("Eventos",
                        sidebarLayout(
                          sidebarPanel(
                            
                          ),
                          mainPanel(
                            plotOutput("plot")
                          )
                        )
               ),
               tabPanel("Equipos",
               ),
               tabPanel("Atletas",
                          ),
                tabPanel("Logros",
                )
               )
    )
)
