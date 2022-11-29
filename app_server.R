library(ggplot2)
library(plotly)
library(shiny)
library(dplyr)
library(tidyverse)
library(stringr)

# Climate Change Data (OurWorldinData)
climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)
#Part 1: Introduction

server <- function(input, output) {
#First Variable: What is the average value of 'co2' across all countries, in 2015?
  output$summary_stat1 <- renderText({
    average_co2_2015 <- climate_data %>%
      group_by(year) %>% 
      filter(year == 2015) %>% 
      summarise(co2 = mean(co2, na.rm = TRUE)) %>% 
      pull(co2)
    
    return(average_co2_2015)
  })

#Second Variable: When is 'total_ghg' the highest?
  output$summary_stat2 <- renderText({
    highest_total_ghg <- climate_data %>%
      filter(total_ghg == max(total_ghg, na.rm = TRUE)) %>% 
      pull(year)

    return(highest_total_ghg)
  })


#Third Variable: What country had the highest 'ghg_per_capita', in 2015?
  output$summary_stat3 <- renderText({
    highest_ghg_per_capita <- climate_data %>% 
      group_by(year) %>% 
      filter(year == 2015) %>% 
      filter(ghg_per_capita == max(ghg_per_capita, na.rm = TRUE)) %>% 
      pull(country)

    return(highest_ghg_per_capita)
  })
  
# Scatter Plot
  output$scatter_plot <- renderPlotly ({
    plot_data <- climate_data %>% 
      filter(country %in% input$country_pick,
             year <= input$year)
  
    
    visualization <- plot_ly(plot_data,
                             x = ~co2_per_capita,
                             y = ~share_global_co2,
                             type = "scatter",
                             mode = "markers",
                             color = ~country,
                             marker = list(size = 15),
                             text = ~paste(plot_data$country,"<b>,<b>",plot_data$year,
                                           "<br>"),
                             hoverinfo = "text") %>% 
    
    layout(title = "CO2 Emissions Per Capita Compared to Global Share",
             xaxis = list(title = "CO2 Emissions Per Capita (Tonnes per Person)"),
             yaxis = list(title = "Global Share Co2 Emissions (%)"))
      
    return(visualization)
      
    })
  }

