library(shiny)
library(dplyr)
library(ggplot2)

cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)

genre <- cleaned_reviews %>%
  distinct(genre)
  
my_ui <- fluidPage (
  sidebarLayout(
    sidebarPanel(
      selectInput('genre', label = "Choose a Music Genre:",
                  genre)
    ),
    mainPanel(
      plotOutput('plot2')
    )
  )
)

shinyUI(my_ui)