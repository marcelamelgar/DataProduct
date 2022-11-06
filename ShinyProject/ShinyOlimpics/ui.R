
library(shiny)
library(shinythemes)
library(markdown)
library(lubridate)
library(shinyWidgets)

shinyUI(fluidPage(theme = shinytheme("sandstone"),

    navbarPage("Juegos Olimpicos",
               tabPanel("Eventos",
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
               tabPanel("Equipos",
               ),
               tabPanel("Atletas",
                        sidebarLayout(
                          sidebarPanel(
                            h2('Atletas Olimpicos'),
                            br(),
                            sliderInput('ChooseParticipation', 'Seleccione Rango de Participaciones:',
                                        value = c(2,5),
                                        min = min(countAtletas$participacion), max = max(countAtletas$participacion),
                                        step = 1)
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
                tabPanel("Logros",
                )
               )
    )
)
