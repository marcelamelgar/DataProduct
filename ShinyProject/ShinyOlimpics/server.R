library(shiny)
library(crosstalk)
library(DT)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(highcharter)

shinyServer(function(input, output, session) {
  
  #### EVENTOS ####
  Events <- athlete_events %>%
    distinct(City, Year, Season) %>%
    arrange(Year)
  
  output$tablaEventos <- renderDataTable({
    dt <- Events %>%
      filter(Year >= input$ChooseYear[1] & Year <= input$ChooseYear[2]) %>%
      filter(City %in% input$selectHost) %>%
      filter(Season %in% input$chkboxSeason)
    dt
  })
  
  observeEvent(input$clean,{
    updatePickerInput(session, 'selectHost', choices = unique(sort(athlete_events$City)),options = list(`actions-box` = TRUE))
    updateSliderInput(session, 'ChooseYear', value = c(min(athlete_events$Year), max(athlete_events$Year)))
    updateCheckboxGroupInput(session, 'chkboxSeason', choices = unique(athlete_events$Season), selected=NULL, inline = TRUE)
  })
  
  #### EQUIPOS ####
  
  Equipos <- athlete_events %>%
    distinct(Team, NOC, Sport, Event, Games) %>%
    arrange(Games)
  Equipos

  countSports <- Equipos %>%
    select(Team, NOC, Sport) %>%
    group_by(NOC) %>%
    summarise(deportes = n_distinct(Sport))
  
  observe({
    query <- parseQueryString(session$clientData$url_search)
    team <- query[["team"]]
    if(!is.null(team)){
      updateSelectInput(session, 'team', selected = team)
    }
  })
  
  observe({
    team <- input$chooseTeam
    
    if(session$clientData$url_port==''){
      x <- NULL
    } else {
      x <- paste0(":",
                  session$clientData$url_port)
    }
    
    marcador<-paste0("http://",
                     session$clientData$url_hostname,
                     x,
                     session$clientData$url_pathname,
                     "?","team=",
                     team,'&')
    updateTextInput(session,"url_param",value = marcador)
  })
  
  output$tablaEquipos <- renderDataTable({
    
    x <- Equipos
    team <- input$chooseTeam
    
    dt <- Equipos %>%
      filter(NOC %in% input$chooseTeam)
    dt
  })
  
  output$plotEquipos <- renderPlot({
    df <- countSports %>%
      filter(NOC %in% input$chooseTeam)

      ggplot(df,  mapping = aes(x=df$NOC, y=df$deportes)) + 
      geom_bar(position="stack", stat="identity")+
      xlab("Equipo")+
      ylab("Deportes")+
      ggtitle("Cantidad de Deportes en los que ha participado el equipo")
  })
  
  #### ATLETAS ####
  
  sex <<- NULL
  age <<- NULL
  
  atletas <- reactive({
    if(!is.null(input$season)&!is.null(input$year)&!is.null(input$sport)){
      sex <<- athlete_events%>%
        select(Season,Year,Sport,Sex)%>%
        filter(Season == input$season & Year == input$year & Sport == input$sport)
      
      age <<- athlete_events%>%
        select(Season,Year,Sport,Age)%>%
        filter(Season == input$season & Year == input$year & Sport == input$sport)
    }
  })
  
  output$plotSexo <- renderPlot({
    atletas()
    if (nrow(sex)!=0){
      barplot(table(sex$Sex), main = "Cantidad de atletas",
              names.arg = c("Mujeres","Hombres"), col = c("pink","lightblue"),
              horiz = TRUE)
    }
  })
  
  output$plotEdades <- renderPlot({
    atletas()
    if (nrow(age)!=0){
      hist(age$Age, main = "Distribución de edades", 
           xlab = "Edad", col = "lightblue", 
           breaks = seq(min(age$Age), max(age$Age), length.out = 6))
    }
  })
  
  Atletas <- athlete_events %>%
    distinct(Name, Games)
  Atletas
  
  countAtletas <- Atletas %>%
    select(Name, Games) %>%
    group_by(Name)%>%
    summarise(participacion = n_distinct(Games))
  countAtletas
  
  #### LOGROS ####

})
