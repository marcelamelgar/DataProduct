
library(shiny)
library(shinythemes)
library(markdown)
library(lubridate)
library(shinyWidgets)

shinyUI(fluidPage(theme = shinytheme("sandstone"),

    navbarPage("Juegos Olimpicos",
               tabPanel("Eventos", icon = icon("fa-light fa-calendar-star"),
                        sidebarLayout(
                          sidebarPanel(
                            h2('Eventos Olimpicos'),
                            h4('Complete los 3 filtros para ver su informacion'),
                            br(),
                            sliderInput('ChooseYear', 'Seleccione Rango de Años:',
                                        value = c(min(athlete_events$Year), max(athlete_events$Year)),sep = "", 
                                        min = min(athlete_events$Year), max = max(athlete_events$Year),
                                        step = 4),
                            br(),
                            pickerInput('selectHost', 'Seleccione Ciudad Host:',
                                        choices = unique(sort(athlete_events$City)),
                                        options = list(`actions-box` = TRUE),
                                        multiple = T),
                            br(),
                            checkboxGroupInput('chkboxSeason', 'Seleccione Temporada:',
                                               choices = unique(athlete_events$Season),
                                               selected = NULL, inline = TRUE),
                            br(),
                            actionButton("clean","Limpiar")
                          ),
                          mainPanel(
                            dataTableOutput("tablaEventos")
                          )
                        )
               ),
               tabPanel("Equipos", icon = icon("fa-thin fa-users-viewfinder"),
               ),
               tabPanel("Atletas", icon = icon("fa-thin fa-ranking-star"),
                        sidebarLayout(
                          sidebarPanel(
                            h2('Atletas Olimpicos'),
                            br(),
                            #sliderInput('ChooseParticipation', 'Seleccione Rango de Participaciones:',
                            #            value = c(2,5),
                            #            min = min(countAtletas$participacion), max = max(countAtletas$participacion),
                            #            step = 1),
                            br(),
                            checkboxGroupInput('season','Season',choices = unique(athlete_events$Season), 
                                               selected = unique(athlete_events$Season), inline = TRUE),
                            br(),
                            numericInput('year','Year',value = 2000, step = 2, min = min(athlete_events$Year), 
                                         max = max(athlete_events$Year)),
                            br(),
                            selectInput('sport', 'Sport', choices = unique(athlete_events$Sport),selected = athlete_events$Sport[1]),
                            br(),
                            actionButton("apply","Apply")
                          ),
                          mainPanel(
                            tabsetPanel(
                              tabPanel(
                                "Informacion General",
                                h2("Informacion Atletas"),
                                fluidRow(
                                  column(12, dataTableOutput('tablaAtletas'))
                                )
                              ),
                              tabPanel(
                                "Edad y Sexo",
                                fluidRow(
                                  column(6, 
                                         h4("Grafica Sexo"),
                                         plotOutput('plotSexo')),
                                  column(6,
                                         h4("Grafica Edades"),
                                         plotOutput('plotEdades'))
                                )
                              )
                            )
                          )
                        )
                          ),
                tabPanel("Logros", icon = icon("fa-duotone fa-medal"),
                )
               )
    )
)
