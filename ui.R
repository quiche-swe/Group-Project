cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
genre <- cleaned_reviews %>%
  distinct(genre)

my_ui <- fluidPage(
  # title
   titlePanel("Options"),
   sidebarLayout(
     sidebarPanel(
         selectInput("select", label = h3("Genre"),
                     choices = list("Electronic" = 1, "Experimental" = 2, "Folk and Country" = 3, "Global (int'l. music)" = 4, "Jazz" = 5,
                                    "Metal" = 6, "Pop" = 7,"Rap" = 8, "Rock" = 9, "Undefined (No genre labeled)" = 10),
                     selected = 7
         ),
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

