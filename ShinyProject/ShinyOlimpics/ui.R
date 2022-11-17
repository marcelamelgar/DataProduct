library(shiny)
library(shinythemes)
library(markdown)
library(shinyWidgets)
library(rsconnect)
library(dplyr)

#Dataset
athlete_events <<- read.csv("https://raw.githubusercontent.com/marcelamelgar/DataProduct/main/ShinyProject/ShinyOlimpics/athlete_events.csv")

Atletas <<- athlete_events %>%
  distinct(ID, Name, Sex,Sport, Team,Age,Games)

countAtletas <<- Atletas %>%
  select(Name, Games) %>%
  group_by(Name)%>%
  summarise(participacion = n_distinct(Games))

mergedAtletas <<-merge(Atletas, countAtletas, by="Name")

Equipos <<- athlete_events %>%
  distinct(Team, NOC, Sport, Event, Games) %>%
  arrange(Games)

countSports <<- Equipos %>%
  select(Team, NOC, Sport) %>%
  group_by(NOC) %>%
  summarise(deportes = n_distinct(Sport))

filteredEquipos <<- Equipos %>%
  select(NOC, Sport) %>%
  group_by(NOC,Sport) %>%
  summarise(participaciones = n())

#UI app

shinyUI(fluidPage(

    navbarPage("Juegos Olimpicos",
               tabPanel("Eventos", icon = icon("fa-thin fa-flag"),
                        sidebarLayout(
                          sidebarPanel(
                            h2('Eventos Olimpicos'),
                            h5('Complete los filtros para conocer la ciudad anfitriona'),
                            br(),
                            sliderInput('ChooseYear', 'Seleccione Rango de Años:',
                                        value = c(min(athlete_events$Year), max(athlete_events$Year)),sep = "", 
                                        min = min(athlete_events$Year), max = max(athlete_events$Year),
                                        step = 2),
                            br(),
                            checkboxGroupInput('chkboxSeason', 'Seleccione Temporada:',
                                               choices = unique(athlete_events$Season),
                                               selected = NULL, inline = TRUE),
                            br(),
                            actionButton("clean","Limpiar")
                          ),
                          mainPanel(
                            DT::dataTableOutput("tablaEventos")
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
                                     DT::dataTableOutput("tablaEquipos")
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
                                h3("Informacion Atletas"),
                                fluidRow(
                                  column(12,DT::dataTableOutput('tablaAtletas'))
                                ),
                                fluidRow(
                                  h3("Atletas seleccionados"),
                                  column(12, DT::dataTableOutput('selectedAtletas'))
                                )
                              ),
                              tabPanel(
                                "Edad y Sexo",
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
                                         plotOutput('plotSexo'),
                                         verbatimTextOutput("opcionalA")),
                                  column(6,
                                         h4("Grafica Edades"),
                                         plotOutput('plotEdades'),
                                         verbatimTextOutput("opcionalB"))
                                )
                              )
                            )
                          )
                        )
                          ),
                tabPanel("Logros", icon = icon("fa-duotone fa-medal"),
                         sidebarLayout(
                           sidebarPanel(
                             h2('Resultados'),
                             sliderInput('edad2', 'Seleccione rango de edades:',
                                         value = c(min(athlete_events$Age[!is.na(athlete_events$Age)]),
                                                   max(athlete_events$Age[!is.na(athlete_events$Age)])),
                                         min = min(athlete_events$Age[!is.na(athlete_events$Age)]), 
                                         max = max(athlete_events$Age[!is.na(athlete_events$Age)]),
                                         step = 5),
                             br(),
                             selectInput('team2', 'Seleccione un equipo', 
                                         choices = unique(athlete_events$Team)),
                             br(),
                             selectInput('year2', 'Seleccione el año', 
                                         choices = unique(sort(athlete_events$Year))),
                             br()
                           ),
                           mainPanel(
                             tabsetPanel(
                               tabPanel(
                                 "Medallas",
                                 h3("Resultados del equipo"),
                                 fluidRow(
                                   column(12, plotOutput('plotlogros'))
                                 )
                               ),
                               tabPanel(
                                 "Carga y Busqueda de Logros",
                                 h3("Carga de Archivo con Atletas para verificar sus logros"),
                                 fluidRow(
                                   column(12,
                                          fileInput("file_input", 'Cargar Archivo', buttonLabel = 'Buscar',
                                                    placeholder = 'No hay archivo seleccionado')
                                          ),
                                 ),
                                 fluidRow(
                                   column(12,
                                          DT::dataTableOutput('tablaCargada'))
                                 ),
                                 h2("Logros alcanzados por Atletas seleccionados"),
                                 fluidRow(
                                   column(12,
                                          DT::dataTableOutput('tablasoloLogros'))
                                 )
                               )
                             )
                           )
                         )
                )
               )
    )
)
