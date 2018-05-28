library(shiny)
library(dplyr)
library(ggplot2)

my_server <- function(input, output) {
  reactive_genre <- reactive({
    input$genre
  })
  
  output$plot2 <- renderPlot({
    filter_genre <- cleaned_reviews %>%
      filter(genre == reactive_genre()) %>%
      select(genre, score, pub_year) %>%
      group_by(pub_year) %>%
      summarise(average = mean(score))
    
    p2 <- ggplot(data = filter_genre) +
      geom_line(mapping = aes(x = pub_year, y = average)) +
      geom_point(mapping = aes(x = pub_year, y = average, color = reactive_genre())) +
      labs(
        title = "Genre Popularity Over Time", 
        x = "Year (year)", # x-axis label 
        y = "Score (out of 10)", # y-axis label 
        color = "Genre"
      )
    p2
  })
}

shinyServer(my_server)