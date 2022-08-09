
library(shiny)

shinyUI(fluidPage(

    titlePanel("Shiny Inputs Glossary"),

    sidebarLayout(
        sidebarPanel(
            h1("Inputs"),
            numericInput("ninput", "Ingrese un numero:",
                         value = 10, step = 10),
            sliderInput('slinput', "Seleccione un porcentaje:",
                        min = 0, max = 100, step = 1, value = 0,
                        post = '%')
        ),

        mainPanel(
            h1("Outputs"),
            h2("Numeric Input"),
            verbatimTextOutput('out_numeric_input'),
            
            h2("Slider Input"),
            verbatimTextOutput('out_slider_input')
        )
    )
))
