my_ui <- fluidPage(
    # title
    titlePanel("Options"),
    
    sidebarLayout(
      
      sidebarPanel(
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