library(magrittr)
library(dplyr)
library(ggplot2)
library(plotly)
library(shinythemes)
source("uniqueCalc.R")

my_server <- function(input, output) {
   # Plot for genre and time to see scores of albums
   # Scatter plot
   plot_1 <- reactive({
      reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
      if (input$genre1 != "all") {
         genre_reviews <- filter(reviews, genre == input$genre1)
         genre_reviews <- filter(genre_reviews, pub_year == input$year)
      } else {
         genre_reviews <- filter(reviews, pub_year == input$year)
      }
      
      x <- list(
         title = "Artist (hover to see name)",
         showticklabels = FALSE)
      
      y <- list(title = "Album Score (out of 10)")
      
      t <- paste(input$genre1, "albums and their scores", sep = " ")
      t <- paste(t, "in", sep = " ")
      t <- paste(t, input$year)
      
      plot_1 <- plot_ly(data = genre_reviews, 
                        type = "scatter",
                        mode = "markers",
                        x = ~artist, y = ~score,
                        color = ~score,
                        hoverinfo = "text",
                        text = paste0("Artist: ", genre_reviews$artist, "<br>",
                                     "Album: ", genre_reviews$title, "<br>",
                                     "Score: ", genre_reviews$score, "<br>",
                                     "Genre: ", genre_reviews$genre)) %>%
         layout(xaxis = x, yaxis = y, title = toString((t)))
      
      return(plot_1)
   })
   
   # Output the plot
   output$plot_1 <- renderPlotly({(plot_1())})
   
   # PLot description
   output$plot1_info <- renderText({
      plot_1()
      plot1_info <- "In this scatter plot the rating of an album is shown on the y-axis and the artist is shown on  
                     the x-axis. The plot can be interacted with so that a user can choose a genre and a year to  
                     see how the albums in that genre scored that year. Furthermore, the user can hover over the 
                     points on the plot to get the artist name, the album name, along with the album score. Albums
                     are scored on a 0.0 - 10.0 scale. If the artist is undefined (such as in the case of pop and
                     r&b music in 2017), then the point will be given a 0.0, accredited to an empty artist."
      return(plot1_info)
   })
   
   # Corina's part
   # Album scores based on how big labels are, scatter plot
   plot_2 <- reactive({
      cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
      cut_of_label <- filter(cleaned_reviews, label_count >= input$range[1] & label_count <= input$range[2])
      
      plot_2 <- ggplot(cut_of_label, aes(x = label_count, y = score)) + 
         geom_point(aes(color = label_count)) + 
         labs(
            title = "Album Rating by Size of Record Label", 
            x = "Size of Record Label", # x-axis label 
            y = "Score (out of 10)", # y-axis label 
            color = "Number of albums label has produced"
         )
      return(plot_2)
   })
   # Output the plot
   output$plot_2 <- renderPlot({plot_2()})
   # Plot description
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
   # Reactive inputs
   reactive_genre <- reactive({
      input$genre2
      input$my_click_key
   })
   
   # Clicking function
   observeEvent(input$my_click_key, {
      reactive_genre()
      output$plot3_info <- renderPrint({
         paste0("As shown by the graph above, the average rating score of ",input$genre2, " is ",
                round(as.double(input$my_click_key$y), 2), " in ", round(as.double(input$my_click_key$x, 2)))
      })
   })
   
   # Plot for how genre average scores change over time
   output$plot_3 <- renderPlot({
      reactive_genre()
      cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
      filter_genre <- cleaned_reviews %>%
         filter(genre == input$genre2) %>%
         select(genre, score, pub_year) %>%
         group_by(pub_year) %>%
         summarise(average = mean(score))
      
      plot_3 <- ggplot(data = filter_genre) +
         geom_line(mapping = aes(x = pub_year, y = average)) +
         geom_point(mapping = aes(x = pub_year, y = average, color = input$genre2)) +
         labs(
            title = "Genre Ratings Over Time", 
            x = "Year (year)", # x-axis label 
            y = "Score (out of 10)", # y-axis label 
            color = "Genre"
         )
      return(plot_3)
   })
   
   # Plot description
   output$plot3_info <- renderText({
      plot3_info <- paste("In this line graph titled \"Genre Popularity Over Time\" the score out of 10 is shown on the y-axis,
                          and the year is shown on the x-axis. The user can filter for the genre of music they want and see
                          how that genres music has changed over time. Right now the plot is showing", input$genre2, sep = " ")
      plot3_info <- paste(plot3_info, "music.", sep = " ")
      return(plot3_info)
   })
   
   # Jensen's part
   # Output table based on reactive inputs
   output$plot_4 <- renderTable({
      input_table <- unique_albums %>%
         filter(tolower(input$uq_search) == artist)
   })
}

shinyServer(my_server)

