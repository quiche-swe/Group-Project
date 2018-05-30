library(magrittr)
library(dplyr)
library(ggplot2)
library(plotly)
library(glue)
source("uniqueCalc.R")

cleaned_reviews <- read.csv(file = "data/cleaned_reviews.csv", stringsAsFactors = FALSE)
genre <- cleaned_reviews %>%
   distinct(genre)


my_ui <- fluidPage(
   # title
   titlePanel("Options"),
   sidebarLayout(
      sidebarPanel(
         selectInput("genre", label = ("Choose a genre"),
                     choices = list("Electronic" = "electronic", "Experimental" = "experimental", "Folk and Country" = "folk/country", "Global (int'l. music)" = "global", "Jazz" = "jazz",
                                    "Metal" = "metal", "Pop and R&B" = "pop/r&b", "Rap" = "rap", "Rock" = "rock", "Undefined (No genre labeled)" = ""),
                     selected = "pop/r&b"),
         sliderInput("year", "Year:",
                     min = 1999, max = 2017,
                     value = 2015),
         sliderInput("range", "Range:",
                     min = 1, max = 475,
                     value = c(1,475)),
         # selectInput('g', label = "Choose a Music Genre:",
         #             genre),
         textInput("uq_search", label = h3("Search for Artist"), value = "Enter artist...")),
      mainPanel(
         # tabsetPanel(type = "tabs",
         #             tabPanel("Ratings of Albums by Genre and Year", plotlyOutput("plot_1"), p(textOutput("plot1_info"))),
         #             tabPanel("Ratings by Label Size", plotOutput("plot_2"), p(textOutput("plot2_info"))),
         #             tabPanel("Line Graph Plot", plotOutput('plot_3'), click = ('my_click_key'), verbatimTextOutput('plot2_info')),
         #             tabPanel("Unique Artist Search", tableOutput('plot_4'))
         # )
         plotlyOutput("plot_1"),
         plotOutput("plot_2"),
         plotOutput("plot_3", click = "my_click_key"),
         verbatimTextOutput('plot3_info'),
         tableOutput("plot_4")
      )
   )
)

shinyUI(my_ui)
   