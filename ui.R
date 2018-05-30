library(magrittr)
library(dplyr)
library(ggplot2)
library(plotly)
library(shinythemes)
source("uniqueCalc.R")

my_ui <- fluidPage(
   navbarPage(title = "Pitchfork Music Reviews"),
      theme = shinytheme("sandstone"),
      tabPanel("Overview",
               mainPanel(
                  tags$h1("Pitchfork Music Review Data"),
                  tags$div(
                     tags$h3("Data-source"),
                     tags$p("Pitchfork is a music-centered magazine, originally started in 1995 by Ryan Schreiber with a focus on reviewing new music. 
                            Since then it has grown to be one the world's most influential music magazine, up there with Billboard, Rollings Stone, and XXL. 
                            This data-set comes from Nolan Conway of kaggle who scraped over 18,000 music reviews from 1999 to January 2017. The data originally
                           came as an sqlite database and was then exported as a .csv database via DB Browser. Music fans from all around can appreciate the
                           sheer volume of album reviews."),
                     tags$h3("Data features: "),
                     tags$p("Within the database are 6 data-sets: artists (a table of artist names and their unique review ID), content (the holistic review of the album), 
                            labels (a table of recording labels and their corresponding albums), reviews (a table containing scores and technical information), and years (a table containing the album years).
                            We've aggregated the data to form one single one to draw from comprised of:"),
                     tags$ul(
                        tags$li("Review ID of each unique review"),
                        tags$li("Record label associated with the album that was reviewed"),
                        tags$li("The genre of the album (decided by Pitchfork)"),
                        tags$li("The title of the album that was reviewed"),
                        tags$li("The artist of the album"),
                        tags$li("The score that the album received (out of 10.0)"),
                        tags$li("The year of review")
                     ),
                     tags$h2("Audience: "),
                     tags$p("Anyone who enjoys listening to music (and we have yet to meet someone who doesn't like music) will find this interesting. 
                            However, we feel like those who are passionate about music, regardless of the genre, can really appreciate this data.
                            And so, we've decided to focus this more on those who care about how influencial a company like Pitchfork can be with their reviews."),
                     tags$h3("Questions asked"),
                     tags$p("There were four main questions that we wanted to find out about this data:"),
                     tags$ul(
                        tags$li("Is there a correlation or even bias of how an album scores due to its genre?"),
                        tags$li("Does being a part of a big(ger) record label correlate in an artist producing higher \"quality\" albums?"),
                        tags$li("How have reviews for a specific genre changed over time: are some genres \"timeless\" as they are toted to be?"),
                        tags$li("How has the popularity and quality of an artists' work changed over time?")
                     )
                     ),
                  tags$h1("Authors"),
                  tags$div(
                     tags$p("Jensen Anderson, Corina Geier, Ellie Qian, and Vince Quach"),
                     tags$p("We are students at the University of Washington currently taking Informatics 201: Technical Foundations")
                  )
                     )
               ), # end mainTabPanel 0
      tabPanel("Genre",
               titlePanel("How do albums of specific genres score based on year? Has there been a drop in quality as new artists emerge?"),
               sidebarLayout(
                  sidebarPanel(
                     tags$h3("Change the genre and year to see the scoring of albums during that year"),
                     selectInput("genre1", label = ("Choose a genre"),
                                 choices = list("Electronic" = "electronic", "Experimental" = "experimental", "Folk and Country" = "folk/country", "Global (int'l. music)" = "global", "Jazz" = "jazz",
                                                "Metal" = "metal", "Pop and R&B" = "pop/r&b", "Rap" = "rap", "Rock" = "rock", "Undefined (No genre labeled)" = "", "All" = "all")),
                     sliderInput("year", "Year:",
                                 min = 1999, max = 2017,
                                 value = 2015),
                     tags$hr()
                  ),
                  mainPanel(
                     tabsetPanel(
                        tabPanel("Graph", plotlyOutput("plot_1"),
                                 tags$p("Hover over the points on the plot to see artist name, album name, score, and genre")),
                        tabPanel("Findings",
                                 tags$br(),
                                 tags$p("WRITE UP FINDINGS"),
                                 tags$p("WRITE UP MORE IF YOU NEED"))
                     )
                  )
               )
      ), # End of tabPanel 1
      tabPanel("Label Size",
               titlePanel("Does being a part of a big(ger) record label correlate in an artist producing higher scoring albums?"),
               sidebarLayout(
                  sidebarPanel(
                     tags$h3("Select the record label size"),
                     sliderInput("range", "Range:",
                                 min = 1, max = 475,
                                 value = c(1,475))
                  ),
                  mainPanel(
                     tabsetPanel(
                        tabPanel("Graph", plotOutput("plot_2"),
                                 tags$p("Use the slider to filter the table for album sizes; the number represents how many albums the label has 
                                        produced within the dataframe and so we extrapolated that the more albums a label produced, the bigger they were")),
                        tabPanel("Findings",
                                 tags$br(),
                                 tags$p("WRITE UP FINDINGS"),
                                 tags$p("WRITE UP MORE IF YOU NEED"))
                                 )
               )
               )
      ), # End of tabPanel 2
      tabPanel("Genres/Time",
               titlePanel("How have genres as a whole (in terms of score) changed over time?"),
               sidebarLayout(
                  sidebarPanel(
                     tags$h3("Select a genre"),
                     selectInput("genre2", label = ("Choose a genre"),
                                 choices = list("Electronic" = "electronic", "Experimental" = "experimental", "Folk and Country" = "folk/country", "Global (int'l. music)" = "global", "Jazz" = "jazz",
                                                "Metal" = "metal", "Pop and R&B" = "pop/r&b", "Rap" = "rap", "Rock" = "rock", "Undefined (No genre labeled)" = ""))
                  ),
                  mainPanel(
                     tabsetPanel(
                        tabPanel("Graph", plotOutput("plot_3"), verbatimTextOutput('plot3_info'),
                                 tags$p("Use the dropdown menu to filter the graph to see how differen genres have changed over time.")),
                        tabPanel("Findings",
                                 tags$br(),
                                 tags$p("WRITE UP FINDINGS"),
                                 tags$p("WRITE UP MORE FINDINGS"))
                     )
                  )
               )
      ),# End of tabPanel 3
      tabPanel("Artist",
               titlePanel("How has the quality of an artist's work changed over time"),
               sidebarLayout(
                  sidebarPanel(
                     tags$h3("Search an artist"),
                     textInput("uq_search", label = h3("Search for Artist"), value = "Enter artist...")
                  ),
                  mainPanel(
                     tabsetPanel(
                        tabPanel("Table", tableOutput("plot_4"),
                                 tags$p("Type in an artists' name to get their albums (case non-sensitive but spelling is!)")),
                        tabPanel("Findings",
                                 tags$br(),
                                 tags$p("WRITE UP FINDINGS"),
                                 tags$p("WRITE UP MORE"))
                     )
                  )
               )
      ), # End of tabPanel 4
      tabPanel("Conclusions",
               mainPanel(
                  tags$div(
                     tags$h3("Is there a correlation or even bias of how an album scores due to its genre?"),
                     tags$p("ANSWER THAT QUESTION"),
                     tags$h3("Does being a part of a big(ger) record label correlate in an artist producing higher \"quality\" albums?"),
                     tags$p("ANSWER THAT QUESTION"),
                     tags$h3("How have reviews for a specific genre changed over time: are some genres \"timeless\" as they are toted to be?"),
                     tags$p("ANSWER THAT QUESTION"),
                     tags$h3("How has the popularity and quality of an artists' work changed over time?")
                  ),
                  tags$div(
                     tags$h3("Conclusion"),
                     tags$p("ANSWER THE CONCLUSION")
                  )
               )
      ) # End of tabPanel 5
)

shinyUI(my_ui)
