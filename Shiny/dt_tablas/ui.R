
library(shiny)
library(DT)

shinyUI(fluidPage(

    titlePanel("Tablas en Shiny"),

    fluidRow(column(6,
                    h1('Single Select Row'),
                    dataTableOutput('tabla_1'),
                    verbatimTextOutput('output_1')
                    ),
             
             column(6,
                    h1('Multiple Select Row'),
                    dataTableOutput('tabla_2'),
                    verbatimTextOutput('output_2')
                    )
             ),
    
    fluidRow(column(6,
                    h1('Single Select Column'),
                    dataTableOutput('tabla_3'),
                    verbatimTextOutput('output_3')
    ),
    
    column(6,
           h1('Multiple Select Column'),
           dataTableOutput('tabla_4'),
           verbatimTextOutput('output_4')
    )
    )
))
