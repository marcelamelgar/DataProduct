
library(shiny)
library(DT)

shinyUI(fluidPage(

    titlePanel("Ejemplo Cargador de Archivos"),

    sidebarLayout(
        sidebarPanel(
            fileInput("file_input", 'Cargar Archivo', buttonLabel = 'Buscar',
                      placeholder = 'No hay archivo seleccionado')
        ),

        mainPanel(
            dataTableOutput('contenido_archivo')
        )
    )
))
