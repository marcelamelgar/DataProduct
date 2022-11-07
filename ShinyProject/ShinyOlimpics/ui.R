
library(shiny)
library(shinythemes)
library(markdown)
library(lubridate)
library(shinyWidgets)
library(highcharter)

shinyUI(fluidPage(theme = shinytheme("sandstone"),

    navbarPage("Juegos Olimpicos",
               tabPanel("Eventos", icon = icon("fa fa-calendar-o"),
                        sidebarLayout(
                          sidebarPanel(
                            h2('Eventos Olimpicos'),
                            h4('Complete los 3 filtros para ver su informacion'),
                            br(),
                            sliderInput('ChooseYear', 'Seleccione Rango de Años:',
                                        value = c(min(athlete_events$Year), max(athlete_events$Year)),sep = "", 
                                        min = min(athlete_events$Year), max = max(athlete_events$Year),
                                        step = 2),
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
                        sidebarLayout(
                          sidebarPanel(
                            h2('Equipos Participantes'),
                            br(),
                            selectInput('chooseTeam', 'Escoge el NOC del equipo:',
                                        choices = unique(sort(Equipos$NOC)),
                                        selected = NULL),
                            br(),
                            textInput("url_param","Marcador: ",value = "")
                          ),
                        mainPanel(
                          h2("Equipos Olimpicos"),
                          fluidRow(
                              column(12,
                                     dataTableOutput("tablaEquipos")
                                     )
                            ),
                          br(),br(),
                          fluidRow(
                            column(12,
                                   plotOutput('plotEquipos'))
                          )
                          
                        ))
               ),
               tabPanel("Atletas", icon = icon("fa-thin fa-ranking-star"),
                        sidebarLayout(
                          sidebarPanel(
                            h2('Atletas Olimpicos'),
                            h4('Complete los 3 filtros para ver su informacion'),
                            br(),
                            sliderInput('ChooseParticipation', 'Seleccione Rango de Participaciones:',
                                        value = c(2,5),
                                        min = min(countAtletas$participacion), max = max(countAtletas$participacion),
                                        step = 1),
                            br(),
                            pickerInput('filterSport', 'Seleccione Deporte', 
                                        choices = unique(athlete_events$Sport),
                                        options = list(`actions-box` = TRUE),
                                        multiple = T),
                            br(),
                            pickerInput('filterTeam', 'Seleccione Equipo', 
                                        choices = unique(athlete_events$Team),
                                        options = list(`actions-box` = TRUE),
                                        multiple = T),
                            br(),
                            actionButton("clean2","Limpiar")
                          ),
                          mainPanel(
                            tabsetPanel(
                              tabPanel(
                                "Informacion General",
                                h2("Informacion Atletas"),
                                fluidRow(
                                  column(12, dataTableOutput('tablaAtletas'))
                                ),
                                fluidRow(
                                  h3("Seleccion de Atletas"),
                                  column(12, dataTableOutput('selectedAtletas'))
                                )
                              ),
                              tabPanel(
                                "Edad y Sexo",
                                #checkboxGroupInput('season','Season',choices = unique(athlete_events$Season), 
                                #                   selected = unique(athlete_events$Season), inline = TRUE),
                                #br(),
                                #numericInput('year','Year',value = 2000, step = 2, min = min(athlete_events$Year), 
                                #             max = max(athlete_events$Year)),
                                #br(),
                                #selectInput('sport', 'Sport', choices = unique(athlete_events$Sport),selected = athlete_events$Sport[1]),
                                #br(),
                                #actionButton("apply","Apply")
                                br(),
                                fluidRow(
                                  column(3,
                                         checkboxGroupInput('season','Season',choices = unique(athlete_events$Season), 
                                                            selected = unique(athlete_events$Season), inline = TRUE)
                                         ),
                                  column(3,
                                         numericInput('year','Year',value = 2000, step = 2, min = min(athlete_events$Year), 
                                                      max = max(athlete_events$Year))
                                         ),
                                  column(3,
                                         selectInput('sport', 'Sport', choices = unique(athlete_events$Sport),selected = athlete_events$Sport[1])
                                         )
                                ),
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
                         sidebarLayout(
                           sidebarPanel(
                             h2('Atletas Ganadores'),
                             h4('Complete los 3 filtros para ver su informacion'),
                             br()
                           ),
                           mainPanel(
                             tabsetPanel(
                               tabPanel(
                                 "Atletas Oro, Plata y Bronce",
                                 h2("Atletas Ganadores"),
                                 fluidRow(
                                   column(12, dataTableOutput('tablaLogros'))
                                 )
                               ),
                               tabPanel(
                                 "Carga y Busqueda de Logros"
                               )
                             )
                           )
                         )
                )
               )
    )
)
