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
         mainPanel(
         tabsetPanel(type = "tabs",
                     tabPanel("Ratings by Label Size", plotOutput("plot"), p(textOutput("plot_info")))
            )
         )
      )
   )
)