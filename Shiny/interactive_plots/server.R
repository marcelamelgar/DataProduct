library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

shinyServer(function(input, output, session) {
  
  clicks <<- as.data.frame(id = character(),
                           x = double(),
                           y = double())
  
  dbclicks <<- as.data.frame(id = character(),
                           x = double(),
                           y = double())
  
  mousehover <<- as.data.frame(id = character(),
                               x = double(),
                               y = double())
  
  sbrush <<- as.data.frame(id = character(),
                           x = double(),
                           y = double())
  
  clicked <- reactive({
    punto <- nearPoints(mtcars, input$clk, xvar = 'wt', yvar = 'mpg')
    if(is.null(punto)){
      return(NULL)
    }
    clicks <<- rbind(clicks,punto)
    done <- clicks %>%
      filter(!rownames(clicks) %in% rownames(dbclicked()))
  })
  
  dbclicked <- reactive({
    punto <- nearPoints(mtcars, input$dclk, xvar = 'wt', yvar = 'mpg')
    if(is.null(punto)){
      return(NULL)
    }
    dbclicks <<- rbind(dbclicks,punto)
  })
  
  hovering <- reactive({
    punto <- nearPoints(mtcars, input$mhover, xvar = 'wt', yvar = 'mpg')
    mousehover <<- rbind(mousehover, punto)
    if(is.null(input$mhover)){
      mousehover <<- mousehover %>%
        filter(!rownames(mousehover) )
    }
  })
  
  brushed <- reactive({
    punto <- brushedPoints(mtcars, input$mbrush, xvar = 'wt', yvar = 'mpg')
    if(is.null(punto)){
      return(NULL)
    }
    sbrush <<- rbind(sbrush, punto)
    done2 <- sbrush %>%
      filter(!rownames(sbrush) %in% rownames(dbclicked()))
  })

  output$clicks_datos <- DT::renderDataTable({
    DT::datatable(clicked())
  })
  
  output$dbclicks_datos <- DT::renderDataTable({
    DT::datatable(brushed())
  })
  
  output$plot_click_options <- renderPlot({
    plot(mtcars$wt,mtcars$mpg, xlab = "wt", ylab="millas por galon", col = "black", pch = 21)
    points(input$mhover$x, input$mhover$y, col =  "gray", pch = 21)
    df4 <- brushed()
    points(df4$wt, df4$mpg, col =  "blue", pch = 21)
    df <- clicked()
    points(df$wt, df$mpg, col = "green", pch = 21)
    df2 <- dbclicked()
    points(df2$wt, df2$mpg, col = "black", pch = 21)
  })
  
  
})
