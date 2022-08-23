
library(shiny)
library(DT)
library(readr)

shinyServer(function(input, output) {

    archivo_cargado <- reactive({
      contenido_archivo <- input$file_input
      if(is.null(contenido_archivo)){
        return(NULL)
      } else if (grepl('.csv', contenido_archivo$name) ){
        out <- read_csv(contenido_archivo$datapath)
        return(out)
      }
      return(NULL)
    })
    
    output$contenido_archivo <- renderDataTable({
      datatable(archivo_cargado())
    })

})
