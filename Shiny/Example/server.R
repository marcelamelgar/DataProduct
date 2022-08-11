
library(shiny)

shinyServer(function(input, output) {
  
  output$out_numeric_input <- renderPrint({
    print(input$ninput)
  })
  
  output$out_slider_input <- renderPrint({
    print(input$slinput)
  })
  
  output$out_slider_input_multi <- renderPrint({
    print(input$slinputmulti)
  })
  
  output$out_slider_input_animate <- renderPrint({
    print(input$slinputanimate)
  })
  
  output$out_date_input <- renderPrint({
    print(input$date_input)
  })
  
  output$out_range_date_input <- renderPrint({
    print(input$date_range_input)
  })
  
  output$out_select_input <- renderPrint({
    print(input$select_input)
  })
  
  output$out_select_input_2 <- renderPrint({
    print(input$select_input_2)
  })
  
  output$out_check_box <- renderPrint({
    print(input$chkbox_input)
  })
  
  output$out_check_box_group <- renderPrint({
    print(input$chkbox_group_input)
  })
})
