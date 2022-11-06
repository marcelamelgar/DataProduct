library(shiny)
library(crosstalk)
library(DT)
library(dplyr)
library(tidyverse)
library(ggplot2)

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

})
