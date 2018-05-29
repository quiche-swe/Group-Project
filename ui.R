library(magrittr)
library(dplyr)
library(ggplot2)
library(plotly)
# source("uniqueCalc.R")

cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
genre <- cleaned_reviews %>%
   distinct(genre)

my_ui <- fluidPage(
   # title
   titlePanel("Options"),
   sidebarLayout(
      sidebarPanel(
         selectInput("genre1", label = h3("Genre"),
                     choices = list("Electronic" = "electronic", "Experimental" = "experimental", "Folk and Country" = "folk/country", "Global (int'l. music)" = "global", "Jazz" = "jazz",
                                    "Metal" = "metal", "Pop" = "pop/r&b", "Rap" = "rap", "Rock" = "rock", "Undefined (No genre labeled)" = ""),
                     selected = 7
         ),
         sliderInput("year", "Range:",
                     min = 1999, max = 2017,
                     value = 2010),
         sliderInput("range", "Range:",
                     min = 1, max = 475,
                     value = c(1,475)
         ),
         sidebarPanel(
            selectInput('genre2', label = "Choose a Music Genre:",
                        genre))
      ),
      mainPanel(
         tabsetPanel(type = "tabs",
                     tabPanel("Vince", plotlyOutput("plot_1"), p(textOutput("plot1_info"))),
                     tabPanel("Ratings by Label Size", plotlyOutput("plot_2"), p(textOutput("plot2_info"))),
                     tabPanel("Ellie", plotOutput("plot_3"), click = 'my_click_key', p(textOutput("plot3_info"))))
         ),
      textInput("uq_search", label = h3("Search for Artist"), value = "Enter artist..."),
         
      tableOutput("plot3")
   )
)



shinyUI(my_ui)

