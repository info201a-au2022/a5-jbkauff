library(ggplot2)
library(plotly)
library(shiny)
library(dplyr)
library(tidyverse)
library(stringr)

# Sources

source("app_server.R")
source("app_ui.R")

# Run the application 

shinyApp(ui = ui, server = server)

