library(magrittr)
library(dplyr)
library(ggplot2)
library(plotly)
source("uniqueCalc.R")

cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
genre <- cleaned_reviews %>%
  distinct(genre)

my_ui <- fluidPage(
  # title
  titlePanel("Options"),
  sidebarLayout(
    sidebarPanel(
      selectInput("select", label = h3("Genre"),
                  choices = list("Electronic" = "electronic", "Experimental" = "experimental", "Folk and Country" = "folk/country", "Global (int'l. music)" = "global", "Jazz" = "jazz",
                                 "Metal" = "metal", "Pop and R&B" = "pop/r&b", "Rap" = "rap", "Rock" = "rock", "Undefined (No genre labeled)" = ""),
                  selected = "pop/r&b"
      ),
      sliderInput("year", "Year:",
                  min = 1999, max = 2017,
                  value = 2015),
      sliderInput("range", "Range:",
                  min = 1, max = 475,
                  value = c(1,475)
      ),
      sidebarPanel(
        selectInput('genre', label = "Choose a Music Genre:",
                    genre))
    ),
    mainPanel(
      #tabsetPanel(type = "tabs",
      # tabPanel("Ratings by Label Size", plotOutput("plot"), p(textOutput("plot_info"))),
      # tabPanel("Line Graph Plot, ", plotOutput('plot2', click = 'my_click_key'), verbatimTextOutput('plot2_info'))
      
      # ),
      p("By choosing a music genre from the left widget, you can see how the popularity of genre changed over time.
        The score (out of 10) is calculated by taking the average score of all the songs belonging to this genre.
        You can also click on the graph to see the exact score and corresponding year."),
      p(" "),
      
      plotOutput('plot2', click = 'my_click_key'),
      verbatimTextOutput('plot2_info'),
      
      plotOutput("plot"), p(textOutput("plot_info"),
                            
                            textInput("uq_search", label = h3("Search for Artist"), value = "Enter artist..."),
                            
                            tableOutput("plot3")
                            
                            
      )
      )
    )
)


shinyUI(my_ui)

