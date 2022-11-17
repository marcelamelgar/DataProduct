library(shiny)
library(DT)
library(dplyr)
library(rsconnect)
library(ggplot2)
library(readr)


shinyServer(function(input, output, session) {
  
  athlete_events <<- read.csv("https://raw.githubusercontent.com/marcelamelgar/DataProduct/main/ShinyProject/ShinyOlimpics/athlete_events.csv")
  
  #### EVENTOS ####
  eventos <- reactive({
    if (!is.null(input$ChooseYear)&!is.null(input$chkboxSeason)){
      Events <<- athlete_events%>%
        distinct(City, Year, Season)%>%
        arrange(Year)%>%
        filter(Year >= input$ChooseYear[1] & Year <= input$ChooseYear[2]) %>%
        filter(Season==input$chkboxSeason)
      return(Events)
    } else{return(Events <<- NULL)}
  })
  
  output$tablaEventos <- DT::renderDataTable({
    eventos()
    if(!is.null(Events)){
      Events%>%
        DT::datatable(filter = "none", 
                      rownames = FALSE,
                      options = list(pageLength = 5, scrollX=TRUE))
      }else{
        a <- athlete_events%>%
          select(Year,Season,City)
        a[0,]%>%
          DT::datatable(filter = "none", 
                        rownames = FALSE,
                        options = list(pageLength = 5,scrollX=TRUE))
      }
  })
  
  observeEvent(input$clean,{
    updateSliderInput(session, 'ChooseYear', value = c(min(athlete_events$Year), max(athlete_events$Year)))
    updateCheckboxGroupInput(session, 'chkboxSeason', choices = unique(athlete_events$Season), selected=NULL, inline = TRUE)
  })
  
  #### EQUIPOS ####
  observe({
    query <- parseQueryString(session$clientData$url_search)
    team <- query[["team"]]
    if(!is.null(team)){
      updateSelectInput(session, "chooseTeam", selected = team)
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
  
  output$tablaEquipos <- DT::renderDataTable({
    dt <- Equipos %>%
      filter(input$chooseTeam == NOC)
    dt%>%
      DT::datatable(filter = "none", 
                    rownames = FALSE,
                    options = list(pageLength = 5,scrollX=TRUE))
  })
  
  output$plotEquipos <- renderPlot({
    df <- filteredEquipos %>%
      filter(input$chooseTeam==NOC)

    ggplot(df, aes(x="", y=participaciones, fill=Sport)) +
      geom_bar(stat="identity", width=1, color="white") +
      coord_polar("y", start=0) +
      ggtitle("Cantidad de Deportes en los que ha participado el equipo")
  })

  
  #### ATLETAS ####
  observeEvent(input$season,{
    updateSelectInput(session, 'sport', 
                      choices = unique(athlete_events$Sport[athlete_events$Season == input$season]), 
                      selected = NULL)
    updateNumericInput(session, 'year', value = unique(athlete_events$Year[athlete_events$Season == input$season])[1])
  })
  
  
  atletas <- reactive({
    sex <<- NULL
    age <<- NULL
    
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
    if (nrow(sex)>1){
      barplot(table(sex$Sex), main = "Cantidad de atletas",
              names.arg = rownames(table(sex$Sex)), col = rainbow(nrow(table(sex$Sex))),
              horiz = TRUE)
    } else{
        print("No hay datos")
    }
  })
  
  output$plotEdades <- renderPlot({
    atletas()
    if (nrow(age)!=0){
      hist(age$Age, main = "Distribución de edades", 
           xlab = "Edad", col = "lightblue", 
           breaks = seq(min(age$Age), max(age$Age), length.out = 6))
    }else{renderPrint({
        print("No hay datos")})}
  })
 
  atls <- reactive({
    if (!is.null(input$filterSport[1]) & !is.null(input$filterTeam[1])){
      atlsdf <<-  mergedAtletas %>%
        filter(participacion >= input$ChooseParticipation[1] & participacion <= input$ChooseParticipation[2])%>%
        filter(Sport %in% input$filterSport)%>%
        filter(Team  %in% input$filterTeam)
    return(atlsdf)
    }else{atlsdf <<- NULL}
  })
  
  
  output$tablaAtletas <- DT::renderDataTable({
    atls()
    if(!is.null(atlsdf)){
      atlsdf%>%
        DT::datatable(rownames = FALSE,
                     filter = 'none',
                     options = list(scrollX=TRUE,
                                    pageLength = 10),
                     selection = "multiple")
    }else{
      mergedAtletas[0,]%>%
        DT::datatable(filter = "none", 
                      rownames = FALSE,
                      options = list(pageLength = 5,scrollX=TRUE))}
  })

  output$selectedAtletas <- DT::renderDataTable({
    atlsdf[input$tablaAtletas_rows_selected,] %>%
      datatable(extensions = "Buttons",
                rownames = FALSE,
                filter = "none",
                options = list(paging = TRUE,
                               scrollX=TRUE, 
                               searching = TRUE,
                               ordering = TRUE,
                               dom = 'Bfrtip',
                               buttons = c('csv'),
                               pageLength=5, 
                               lengthMenu=c(3,5,10) ))
  })
  
  observeEvent(input$clean2,{
    updatePickerInput(session, 'filterSport', choices = unique(sort(athlete_events$Sport)),options = list(`actions-box` = TRUE))
    updatePickerInput(session, 'filterTeam', choices = unique(sort(athlete_events$Team)),options = list(`actions-box` = TRUE))
    updateSliderInput(session, 'ChooseYear', value = c(min(countAtletas$participacion)), max(countAtletas$participacion))
  })
  
  #### LOGROS ####
  
  medallas <- reactive({
    logros <<- NULL
    if(!is.null(input$year2)&!is.null(input$team2)&!is.null(input$year2)){
      logros <<- athlete_events%>%
        select(Age,Team,Year,Medal,Sex)%>%
        filter(Age >= input$edad2[1]&Age <= input$edad2[2] & Year == input$year2 & Team == input$team2 & !is.na(Medal))%>%
        select(Sex, Medal)%>%
        table()
    }
  })
  
  output$plotlogros <- renderPlot({
    medallas()
    if(nrow(logros)!=0){
      barplot(logros,
              col = c("lightblue"),
              main = "Medallas obtenidas",
              xlab = "Medalla",
              ylab = "Cantidad",
              legend.text = rownames(logros),
              args.legend = list(x = "topright",
                                 inset = c(-0.1, -0.45)))
    } else {renderPrint("No hay datos")
    }
  })
  
  
  
  archivo_cargado <- reactive({
    contenido_archivo <- input$file_input
    if(is.null(contenido_archivo)){
      return(NULL)
    } else if (grepl('.csv', contenido_archivo$name) ){
      out <- read_csv(contenido_archivo$datapath)
      return(out)
    }
  })
  
  output$tablaCargada <- DT::renderDataTable({
    if(!is.null(archivo_cargado())){
      DT::datatable(archivo_cargado(), rownames = FALSE, filter = "none", options = list(pageLength = 10,
                                                                       scrollX = TRUE))
    } else{ return(NULL)}
    
  })
  
  mergedLogros <- reactive({
    if(!is.null(archivo_cargado())){
      Logros <- athlete_events%>%
        select(ID, Name, Team, Sport, Games, Medal)
      deefe <- merge(Logros, archivo_cargado(), by = c("ID","Name", "Team", "Sport", "Games"))
      return(deefe)
    } else{return(NULL)}
  })
  
  output$tablasoloLogros <- DT::renderDataTable({
    if (!is.null(mergedLogros())){
    df <- mergedLogros() %>%
      select(Name,Team, Sport, Games,Medal)%>%
      DT::datatable(rownames = FALSE, filter = "none", options = list(pageLenght=5,
                                                                      scrollX = TRUE))%>%
      formatStyle(columns = "Medal",
                  background = styleEqual(c('Gold', 'Silver','Bronze'), c("gold", "darkgrey","lightsalmon")))
    df
    }
  })

})


