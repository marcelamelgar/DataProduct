
library(shiny)
library(lubridate)

shinyUI(fluidPage(

    titlePanel("Shiny Inputs Glossary"),

    sidebarLayout(
        sidebarPanel(
            h1("Inputs"),
            numericInput("ninput", "Ingrese un numero:",
                         value = 10, step = 10),
            sliderInput('slinput', "Seleccione un porcentaje:",
                        min = 0, max = 100, step = 1, value = 0,
                        post = '%'),
            sliderInput('slinputmulti', 'Seleccione Rango:',
                        value = c(10000,30000), 
                        min = 0, max = 150000,
                        step = 1000, pre = 'Q.'),
            sliderInput('slinputanimate', 'Pasos:',
                        value = 0, 
                        min = 0, max = 100,
                        step = 10, animate =TRUE),
            dateInput('date_input', 'Ingrese fecha:',
                      value = Sys.Date(), language = 'es',
                      weekstart = 1, format = 'dd-mm-yyyy'),
            dateRangeInput('date_range_input', 'Seleccione Fechas:', 
                           start = today()-15, end = today(),
                           max = today(), min = today()-365,
                           language = 'es', separator = 'hasta'),
            selectInput('select_input', 'Seleccione Estado:',
                        choices = state.name,
                        selected = state.name[sample(1:length(state.name), size = 1)]),
            selectInput('select_input_2', 'Seleccione Letras:', 
                        choices = letters, selected = 'a', 
                        multiple = TRUE),
            checkboxInput('chkbox_input', 'Enviar Email :',
                          value = FALSE),
            checkboxGroupInput('chkbox_group_input', 'Seleccione opcion:',
                               choices = letters[1:3],
                               selected = NULL, inline = TRUE)
        ),

        mainPanel(
            h1("Outputs"),
            h2("Numeric Input"),
            verbatimTextOutput('out_numeric_input'),
            
            h2("Slider Input"),
            verbatimTextOutput('out_slider_input'),
            
            h3("Slider Input Multiple"),
            verbatimTextOutput('out_slider_input_multi'),
            
            h3("Slider Input Animate"),
            verbatimTextOutput('out_slider_input_animate'),
            
            h2("Date Input"),
            verbatimTextOutput('out_date_input'),
            
            h2("Range Date Input"),
            verbatimTextOutput('out_range_date_input'),
            
            h2("Select Input"),
            verbatimTextOutput('out_select_input'),
            
            h3("Select Input 2"),
            verbatimTextOutput('out_select_input_2'),
            
            h3("CheckBox"),
            verbatimTextOutput('out_check_box'),
            
            h3("CheckBox Group"),
            verbatimTextOutput('out_check_box_group')
        )
    )
))
