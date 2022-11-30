#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# R Shiny server
server <- shinyServer(function(input, output) {
  
  #Univariate analysis
  output$histPlot <- renderPlot({
    #Column name variable
    num_val = ifelse(input$num == 'Temperature', 'temp',
                     ifelse(input$num == 'Feeling temperature', 'atemp',
                            ifelse(input$num == 'Humidity', 'hum',
                                   ifelse(input$num == 'Wind speed', 'windspeed',
                                          ifelse(input$num == 'Casual', 'casual',
                                                 ifelse(input$num == 'New', 'new', 'total'))))))
    
    #Histogram plot
    ggplot(data = bike, aes(x = bike[[num_val]]))+ 
      geom_histogram(stat = "bin", fill = 'steelblue3', 
                     color = 'lightgrey')+
      theme(axis.text = element_text(size = 12),
            axis.title = element_text(size = 14),
            plot.title = element_text(size = 16, face = 'bold'))+
      labs(title = sprintf('Histogram plot of the variable %s', num_val),
           x = sprintf('%s', input$num),y = 'Frequency')+
      stat_bin(geom = 'text', 
               aes(label = ifelse(..count.. == max(..count..), as.character(max(..count..)), '')),
               vjust = -0.6)
    
    output$freqPlot <- renderPlot({
      #Column name variable
      cat_val = ifelse(input$cat == 'Season', 'season',
                       ifelse(input$cat == 'Year', 'yr',
                              ifelse(input$cat == 'Month', 'mnth',
                                     ifelse(input$cat == 'Hour', 'hr',
                                            ifelse(input$cat == 'Holiday', 'holiday',
                                                   ifelse(input$cat == 'Weekday', 'weekday',
                                                          ifelse(input$cat == 'Working day', 'workingday', 'weathersit')))))))
      
      #Frecuency plot
      ggplot(data = bike, aes(x = bike[[cat_val]]))+
        geom_bar(stat = 'count', fill = 'mediumseagreen', 
                 width = 0.5)+
        stat_count(geom = 'text', size = 4,
                   aes(label = ..count..),
                   position = position_stack(vjust = 1.03))+
        theme(axis.text.y = element_blank(),
              axis.ticks.y = element_blank(),
              axis.text = element_text(size = 12),
              axis.title = element_text(size = 14),
              plot.title = element_text(size = 16, face="bold"))+
        labs(title = sprintf('Frecuency plot of the variable %s', cat_val),
             x = sprintf('%s', input$cat), y = 'Count')
      
    })
  })

  