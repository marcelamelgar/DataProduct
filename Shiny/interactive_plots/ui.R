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
             h3("Informacion de Puntos Seleccionados"),
             DT::dataTableOutput("clicks_datos"),
             DT::dataTableOutput("dbclicks_datos")
    )
    
  )
))
