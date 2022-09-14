library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Interaccion con Puntos"),
  
  # Sidebar with a slider input for number of bins
  shiny::tabsetPanel(
    tabPanel("Colores Reactivos",
             plotOutput("plot_click_options",
                        click = "clk",
                        dblclick = "dclk",
                        hover = 'mhover',
                        brush = 'mbrush' ),
             h3("Informacion de Puntos 'Clicked'"),
             DT::dataTableOutput("clicks_datos"),
             h3("Información de Puntos Seleccionados"),
             DT::dataTableOutput("dbclicks_datos")
    )
    
  )
))
