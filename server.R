library("dplyr")
library("ggplot2")

my_server <- function(input, output) {
  reactive_scatter <- reactive({
     # widget one is a dropdown menu of genres
     # widget two is a slider of year
     reactive_genre <- input$genre
     reactive_year <- input$year
     
     reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
     genre_reviews <- filter(reviews, genre == reactive_genre)
     genre_reviews <- filter(reviews, year == reactive_year)
     plot_title <- paste(reactive_genre, "Album Scores in", sep = " ")
     plot_title <- paste(title, reactive_year, sep = " ")
     
     if (identical(input$plotType, "ggplotl")) {
        plot <- ggplot(genre_reviews, aes(x = artist, y = score, color = score)) +
           geom_point() +
           labs(
              title = plot_title,
              x = "",
              y = "Album Score (out of 10.0)"
           )
        ggplotly(plot) %>%
           layout(ragmode = "select")
     } else {
        plot <- plot_ly(genre_reviews, x = ~artist, y = ~score) %>%
           layout(dragmode = "select")
     }
     return(plot)
  })
  
  output$hover <- renderPrint({
     d <- event_data("plotly_hover")
     if (is.null(d)){
        "Artist name appears here (unhover to clear)"
     } else {
        d
     }
  })
}