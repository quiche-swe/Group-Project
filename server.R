library(dplyr)

my_server <- function(input, output) {
  plot <- reactive({
    cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
    cut_of_label <- filter(cleaned_reviews, label_count >= input$range[1] & label_count <= input$range[2])
    ggplot(cut_of_label, aes(x=label_count, y=score)) + 
      geom_point(aes(size=label_count, color=label_count)) + 
      labs(
        title = "Album Rating by Size of Record Label", 
        x = "Size of Record Label", # x-axis label 
        y = "Score (out of 10)", # y-axis label 
        fill = "Number of albums label has produced"
      ) 
  )}
  output$plot <- renderPlot(plot)
  
  output$plot_info <- renderText({
    plot_info <- paste("In this scatter plot titled \"Album Rating by Size of Record Label\" the rating of a song is shown on the y-axis,
                       and the record label size is shown on the x-axis. The size of record label corresponds to the number of albums
                       that the label has produced. The user can filter for the label size. 
                       Right now the plot is showing number of albums produced between", input$range[1], sep = " ")
    plot_info <- paste(plot_info, "and", sep = " ")
    plot_info <- paste(plot_info, input$range[2], sep = " ")
    plot_info <- paste(plot_info, ".")
    return(plot_info)
  })
}
