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
      p("By choosing a music genre from the left widget, you can see how the popularity of genre changed over time.
        The score (out of 10) is calculated by taking the average score of all the songs belonging to this genre.
        You can also click on the graph to see the exact score and corresponding year."),
      p(" "),
      
      plotOutput('plot2', click = 'my_click_key'),
      verbatimTextOutput('plot2_info')
    )
  )
)

shinyUI(my_ui)