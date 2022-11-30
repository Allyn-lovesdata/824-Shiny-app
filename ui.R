#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Load libraries

install.packages("shiny")
install.packages("shinydashboard")
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)

#Importing datasets
Cym <- read.csv('Cymbalta.csv')

Cym$group <- as.factor(Cym$group)
Cym$ASA <- as.factor(Cym$ASA)
Cym$Postoperative_vomiting <- as.factor(Cym$Postoperative_vomiting)
Cym$Sedation_0to8h <- as.factor(Cym$Sedation_0to8h)
Cym$Sedation_9to16h <- as.factor(Cym$Sedation_9to16h)
Cym$Sedation_17to24h <- as.factor(Cym$Sedation_17to24h)

Cym$Postoperative_vomiting<-as.factor(ifelse(Cym$Postoperative_vomiting == 0, 'No', 'Yes'))

#does this run?
Cym$Sedation_0to8h <- as.factor(ifelse(Cym$Sedation_0to8h == 1, 'Awake'),
                                ifelse(Cym$Sedation_0to8h == 2, 'Awake/Tranquil'),
                                ifelse(Cym$Sedation_0to8h == 3, 'Asleep/Responsive'),
                                ifelse(Cym$Sedation_0to8h == 4, 'Asleep/Requires tap'))    

Cym$Sedation_9to16h <- as.factor(ifelse(Cym$Sedation_9to16h == 1, 'Awake'),
                                 ifelse(Cym$Sedation_9to16h == 2, 'Awake/Tranquil'),
                                 ifelse(Cym$Sedation_9to16h == 3, 'Asleep/Responsive'),
                                 ifelse(Cym$Sedation_9to16h == 4, 'Asleep/Requires tap'))    

Cym$Sedation_17to24h <- as.factor(ifelse(Cym$Sedation_17to24h == 1, 'Awake'),
                                  ifelse(Cym$Sedation_17to24h == 2, 'Awake/Tranquil'),
                                  ifelse(Cym$Sedation_17to24h == 3, 'Asleep/Responsive'),
                                  ifelse(Cym$Sedation_17to24h == 4, 'Asleep/Requires tap'))    


ui <- dashboardPage(dashboardHeader(), 
                    dashboardSidebar(),
                    dashboardBody())

#R Shiny ui
ui <- dashboardPage(
  
  #Dashboard title
  dashboardHeader(title ="Preoperative Cymbalta and Morphine Consumption", 
                  titleWidth = 290),
  
  #Sidebar layout
  dashboardSidebar(width = 290,
                   sidebarMenu(menuItem("Plots", tabName = "plots", icon = icon('poll')),
                               menuItem("Dashboard", tabName = "dash", icon = icon('tachometer-alt')))),
  
  #pick variables  
  #Tabs layout
  dashboardBody(tags$head(tags$style(HTML('.main-header .logo {font-weight: bold;}'))),
                tabItems(
                  #Plots tab content
                  tabItem('plots', 
                          #Histogram filter
                          box(status = 'primary', title = 'Filter for the histogram plot', 
                              selectInput('num', "Numerical variables:", c("Age", "BMI", "IV_Fluids", "Operative_times", "Blood_loss", "Time_to_Aldrete_9", "morphine_consumption_24h1",
                                                                           "VAS_basalR", "VAS_basalM", "VAS_2hrR", "VAS_2hrM", "VAS_4hrM", "VAS-4hrR",
                                                                           "VAS_8hrR", "VAS_8hrM", "VAS_12hrR", "VAS_12hrM", "VAS_16hrR", "VAS_16hrM", 
                                                                           "VAS_24hrR", "VAS_24hrM", "QOR_psychological_support", "QOR_emotional_state",
                                                                           "QOR_Physical_comfort", "QOR_physical_independence", "QOR_Pain", "Total")),
                              footer = 'Histogram plot for numerical variables'),
                          #Frequency plot filter
                          box(status = 'primary', title = 'Filter for the frequency plot',
                              selectInput('cat', 'Categorical variables:', c("ASA", "Postoperative_vomiting", "Sedation_0to8h", "Sedation_9to16h", "Sedation_17to24h")),
                              footer = 'Frequency plot for categorical variables'),
                          #Boxes to display the plots
                          box(plotOutput('histPlot')),
                          box(plotOutput('freqPlot'))),
                  
                  #Dashboard tab content
                  tabItem('dash',
                          
                          #Dashboard filters
                          box(title = 'Filters', status = 'primary', width = 12,
                              splitLayout(cellWidths = c('4%', '42%', '40%'),
                                          div(),
                                          radioButtons( 'group', 'Group:', c('0', '30', '60', '90')),
                                          radioButtons( 'Postoperative_vomiting', 'PONV:', c('No', 'Yes')),
                                          radioButtons( 'Sedation_17to24h', 'Modified Ramsey Score:', c('1', '2', '3', '4')))),
                          
                          #Boxes to display the plots
                          box(plotOutput('linePlot')),
                          box(plotOutput('barPlot')), 
                          height = 550)
                  
                  
                  