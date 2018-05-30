library(magrittr)
library(dplyr)
library(ggplot2)
library(plotly)
library(glue)
source("uniqueCalc.R")

my_server <- function(input, output) {
   plot_1 <- reactive({
      reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
      genre_reviews <- filter(reviews, genre == input$genre)
      genre_reviews <- filter(genre_reviews, pub_year == input$year)
      
      x <- list(
         title = "Artist (hover to see name)",
         showticklabels = FALSE)
      
      y <- list(title = "Album Score (out of 10)")
      
      t <- paste(input$genre, "albums and their scores", sep = " ")
      t <- paste(t, "in", sep = " ")
      t <- paste(t, input$year)
      
      plot_1 <- plot_ly(data = genre_reviews, 
                        type = "scatter",
                        mode = "markers",
                        x = ~artist, y = ~score,
                        hoverinfo = "text",
                        text = paste0("Artist: ", genre_reviews$artist, "<br>",
                                     "Album: ", genre_reviews$title, "<br>",
                                     "Score: ", genre_reviews$score)) %>%
         layout(xaxis = x, yaxis = y, title = toString(t))
      
      return(plot_1)
   })
   
   output$plot_1 <- renderPlotly({(plot_1())})
   
   output$plot1_info <- renderText({
      plot1_info <- paste("In this scatter plot titled \"Album Rating by Genre and Year\", the rating of an album is shown on the y-axis and the artist
                          is shown on the x-axis.")
      return(plot1_info)
   })
   
   # Corina's part
   plot_2 <- reactive({
      cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
      cut_of_label <- filter(cleaned_reviews, label_count >= input$range[1] & label_count <= input$range[2])
      
      plot_2 <- ggplot(cut_of_label, aes(x = label_count, y = score)) + 
         geom_point(aes(size = label_count, color = label_count)) + 
         labs(
            title = "Album Rating by Size of Record Label", 
            x = "Size of Record Label", # x-axis label 
            y = "Score (out of 10)", # y-axis label 
            color = "Number of albums label has produced",
            size = "Number of albums label has produced"
         )
      return(plot_2)
   })
   output$plot_2 <- renderPlot({plot_2()})
   
   output$plot2_info <- renderText({
      plot2_info <- paste("In this scatter plot titled \"Album Rating by Size of Record Label\" the rating of a song is shown on the y-axis,
                         and the record label size is shown on the x-axis. The size of record label corresponds to the number of albums
                         that the label has produced. The user can filter for the label size. 
                         Right now the plot is showing number of albums produced between", input$range[1], sep = " ")
      plot2_info <- paste(plot2_info, "and", sep = " ")
      plot2_info <- paste(plot2_info, input$range[2], sep = " ")
      plot2_info <- paste(plot2_info, ".")
      return(plot2_info)
   })
   
   # Ellie's part
   reactive_genre <- reactive({
      input$genre
   })
   
   output$plot_3 <- renderPlot({
      reactive_genre()
      cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
      filter_genre <- cleaned_reviews %>%
         filter(genre == input$genre) %>%
         select(genre, score, pub_year) %>%
         group_by(pub_year) %>%
         summarise(average = mean(score))
      
      plot_3 <- ggplot(data = filter_genre) +
         geom_line(mapping = aes(x = pub_year, y = average)) +
         geom_point(mapping = aes(x = pub_year, y = average, color = input$genre)) +
         labs(
            title = "Genre Popularity Over Time", 
            x = "Year (year)", # x-axis label 
            y = "Score (out of 10)", # y-axis label 
            color = "Genre"
         )
      return(plot_3)
   })
   
   observeEvent(input$my_click_key, {
      output$plot2_info <- renderPrint({
         paste0("As shown by the graph above, the average rating score of ",input$g, " is ",
                round(as.numeric(input$my_click_key$y, 3)), " in ", round(as.numeric(input$my_click_key$x, 2)))
      })
   })
   
   output$plot3_info <- renderText({
      plot3_info <- "By choosing a music genre from the left widget, you can see how the popularity of genre changed over time.
        The score (out of 10) is calculated by taking the average score of all the songs belonging to this genre.
        You can also click on the graph to see the exact score and corresponding year."
      return(plot3_info)
   })
   
   # Jensen's part
   output$plot_4 <- renderTable({
      input_table <- unique_albums %>%
         filter(input$uq_search == artist) 
   })
   
   
}

shinyServer(my_server)

