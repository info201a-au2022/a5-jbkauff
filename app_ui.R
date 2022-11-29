library(ggplot2)
library(plotly)
library(shiny)
library(dplyr)
library(tidyverse)
library(stringr)

climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv", stringsAsFactors = FALSE)

# Home Page

intro_tab <- tabPanel(
# Title
  "Introduction",
  fluidPage(
    h4(strong(em("Background Information"))),
    p("Emissions have become increasingly top-of-mind for countries around the world as climate change
      and negative externalities of our actions have come to light. Using the data of over 207 country profiles
      provided by Our World in Data, it allows the user to explore climate-related statistics for every country 
      in the world spanning over a century. Within this comprehensive data set, I have chosen to focus on a few 
      variables in particular pertaining to CO2 emissions and their differing relationships to countries both large
      and small, developed and developing. With this in mind, we will be looking at the correlation of 'co2_per_capita'
      and 'share_global_co2' over the period in which the data was collected and reported."),
    p("Like previously mentioned, this data set was initially published in May of 2017 by Our World in Data with the 
      help of Hannah Ritchie, Max Roser, and Pablo Rosado."),
    br(),
    h4(strong(em("Summary Statistics"))),
    p(em("First Variable: What is the average value of 'co2' across all countries, in 2015?")),
    p(textOutput("summary_stat1")),
    p("This value of interest is significant in understanding, as a collective society, a quantitative number on the 
      damages that we are dealing to our world. With this number, it is empowering to compare it to earlier years
      and see the exponential increases in average level of CO2 across our planet."),
    br(),
    p(em("Second Variable: When is 'total_ghg' the highest?")),
    p(textOutput("summary_stat2")),
    p("This value of interest is helpful in understanding how our actions have gotten significantly worse in recent years. It 
      is important to note that the data set was compiled through 2020, with the worst being one year prior."),
    br(),
    p(em("Third Variable: What country had the highest 'ghg_per_capita', in 2015?")),
    p(textOutput("summary_stat3")),
    p("This value of interest is helpful in understanding what country has the highest greenhouse gas emission, per capita. I
      chose to include this value as while nations such as China or United States may have the highest overall emissions, that
      doesn't mean that they emit the most per person."),
  )
)


grouped_data <- climate_data %>% 
  group_by(country) %>% 
  summarize(count = n())

count_range <- range(grouped_data$country)

#Widgets
year_range <- range(climate_data$year)
country_unique <- unique(climate_data$country)

#Second Page
country_pick <- selectInput(inputId = "country_pick",
                            label = "Select Country",
                            choices = climate_data$country,
                            selected = country_unique[1],
                            multiple = TRUE)

year_slider <- sliderInput(inputId = "year",
                           label = "Year Range", sep = "",
                           min = min(climate_data$year),
                           max = max(climate_data$year),
                           value = c(1780,2020))

ui <- fluidPage(h1(strong("Exploring Trends in CO2 Emissions Across our World"),
                   style = "color : Navy"),
                
                tabsetPanel(
                  tabPanel("Introduction", intro_tab),
                  tabPanel("Global Share of CO2 Emissions",
                           fluidRow(
                             column(country_pick, width = 6),
                             column(year_slider, width = 6)
                           ),
                           fluidRow(
                             column(plotlyOutput("scatter_plot"), width = 12)),
                           p("I included this chart within this report as I believe it does a great job of showing
                             the relationship of carbon emissions on both a per-capita and global scale. Some trends in the 
                             data is that larger countries, such as United States or China, historically comprised of a large
                             majority of the global share of CO2 emissions but have since declined despite overall numbers 
                             increasing. This increase is shown through the x-axis where nearly every conuntry, both large
                             and small, have experienced a significant increase in the CO2 emissions per capita in recent years.
                             One important thing to note is that you can add multiple nations to the 'Select Country' widget
                             to compare the relationship between the two.")
                           ))
)
                                 
