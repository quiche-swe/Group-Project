library(magrittr)
library(dplyr)
library(ggplot2)
library(plotly)
library(shinythemes)
source("uniqueCalc.R")

my_ui <- fluidPage(
   navbarPage(title = "Pitchfork Data",
      theme = "united.css",
      tabPanel("Overview",
               # Main panel introducing the data
               mainPanel(
                  tags$h1("Pitchfork Music Review Data"),
                  tags$div(
                     tags$h3("Data-source"),
                     tags$p("Pitchfork is a music-centered magazine, originally started in 1995 by Ryan Schreiber with a focus on reviewing new music. 
                            Since then it has grown to be one the world's most influential music magazines, up there with Billboard, Rollings Stone, and XXL. 
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
                     tags$h3("Audience: "),
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
                  tags$h3("Authors"),
                  tags$div(
                     tags$p("Jensen Anderson, Corina Geier, Ellie Qian, and Vince Quach"),
                     tags$p("We are students at the University of Washington currently taking Informatics 201: Technical Foundations")
                  )
               )
            ), # end mainTabPanel
      # Tab 1 to answer question 1
      # Corresponds w/ Vince's part in Server.R
      # Scatter plot of album scores in specific genres
      # Can be played with to change genre and year
      tabPanel("Genre Album Scores",
               titlePanel("How do albums of specific genres score based on year? Has there been a drop in quality as new artists emerge?"),
               sidebarLayout(
                  sidebarPanel(
                     tags$h4("Change the genre and year to see the scoring of albums during that year"),
                     selectInput("genre1", label = ("Choose a genre"),
                                 choices = list("Electronic" = "electronic", "Experimental" = "experimental", "Folk and Country" = "folk/country", "Global (int'l. music)" = "global", "Jazz" = "jazz",
                                                "Metal" = "metal", "Pop and R&B" = "pop/r&b", "Rap" = "rap", "Rock" = "rock", "Undefined (No genre labeled)" = "", "All" = "all"),
                                 selected = "rap"),
                     sliderInput("year", "Year:",
                                 min = 1999, max = 2017,
                                 value = 2015)
                  ),
                  mainPanel(
                     tabsetPanel(
                        tabPanel("Graph", plotlyOutput("plot_1"),
                                 tags$br(),
                                 tags$p("(Hover over the points on the plot to see artist name, album name, score, and genre)"),
                                 textOutput("plot1_info")),
                        tabPanel("Findings",
                                 tags$br(),
                                 tags$p("Here we analyzed the bias of PitchFork reviews regarding genre. We questioned whether there was any sort of indication as to the type of genre the writers for 
                                        PitchFork preferred. We found that rock was the genre that produced the most perfect scores, but it also was the genre with most 0 scoring albums. Pop/R&B 
                                        followed rock with the second highest amount of 10 scoring albums, and had an average score of 6.8 overall, the lowest average of all the genres, whereas 
                                        rock had an average score of 6.9. The genre with highest average score was global with an average of 7.4. This shows that PitchFork writers more consistently 
                                        score global music higher than other genres such as pop and R&B.")
                     )
                  )
               )
               )
      ), # End of tabPanel 1
      # Tab 2 to answer question 2
      # Corresponds w/ Corina's part in Server.R
      # Scatter plot of album scores and label size
      tabPanel("Label Size",
               titlePanel("Does being a part of a big(ger) record label correlate in an artist producing higher scoring albums?"),
               sidebarLayout(
                  sidebarPanel(
                     tags$h4("Select the record label size"),
                     sliderInput("range", "Range:",
                                 min = 1, max = 475,
                                 value = c(1,475))
                  ),
                  mainPanel(
                     tabsetPanel(
                        tabPanel("Graph", plotOutput("plot_2"),
                                 tags$br(),
                                 tags$p("(Use the slider to filter the table for album sizes; the number represents how many albums the label has 
                                        produced within the dataframe and so we extrapolated that the more albums a label produced, the bigger they were)"),
                                 textOutput("plot2_info")),
                        tabPanel("Findings",
                                 tags$br(),
                                 tags$p("Here we analyzed whether an album produced by a big label would have on average, higher scores than albums produced by independent labels, or labels that had 
                                        not produced as many albums. We defined label size by figuring out the number of albums any one record label had produced. We found that being a part of a 
                                        big label did not correlate to higher scores. While smaller record labels did have albums that scored lower than bigger record labels, they also had albums 
                                        that scored equivalent high scores to the bigger record labels. This shows that there is no direct correlation between record label size and average score 
                                        of the album produced.")
                                    )
                                 )
               )
               )
      ), # End of tabPanel 2
      tabPanel("Genres Over Time",
               titlePanel("How have genres as a whole (in terms of score) changed over time?"),
               sidebarLayout(
                  sidebarPanel(
                     tags$h4("Select a genre"),
                     selectInput("genre2", label = ("Choose a genre"),
                                 choices = list("Electronic" = "electronic", "Experimental" = "experimental", "Folk and Country" = "folk/country", "Global (int'l. music)" = "global", "Jazz" = "jazz",
                                                "Metal" = "metal", "Pop and R&B" = "pop/r&b", "Rap" = "rap", "Rock" = "rock", "Undefined (No genre labeled)" = ""))
                  ),
                  mainPanel(
                     tabsetPanel(
                        tabPanel("Graph", plotOutput("plot_3", click = "my_click_key"), verbatimTextOutput('plot3_info'),
                                 tags$br(),
                                 tags$p("(Use the dropdown menu to filter the graph to see how different genres have changed over time.)")),
                        tabPanel("Findings",
                                 tags$br(),
                                 tags$h3("Electronic"),
                                 tags$p("Average scores have increased over time, but they did hav a dip during the punk/scene/goth rock era 
                                        during th early-mid 2000's, but has become better recently. This is likely due to artist's 
                                        like Diplo, Deadmau5, and Zedd emerging."),
                                 tags$h3("Experimental"),
                                 tags$p("Average scores have been all over the place, reminiscent of the genre name. Experimental music has never scored above 
                                        7.75/10.0 but it's been consistently above 7.0 since 2000. It's seems to vary within 7.0 - 7.75"),
                                 tags$h3("Folk/Country"),
                                 tags$p("Folk/Country scores have been very consistent throughout the years. It is consistently scoring in the 7-7.5  range
                                       (note: the dip in 2017 is due to the reviews being from 1999 - January 2017, 
                                        and can be accounted for by a lack of reviews of Folk and Country music in January 2017)."),
                                 tags$h3("Global (international music)"),
                                 tags$p("Global music has been consistently better than average, with averages of 8.0+ scores; 
                                       their dip in 2017 can also be accounted for due to Pitchfork not having reviewed any global albums in Jan, 2017."),
                                 tags$h3("Jazz"),
                                 tags$p("This genre has only dipped below 7.0 once in the last 18 years (2017 is due to no jazz reviews in January).
                                        Jazz is a niche genre that is hard to judge but this data shows consistency in Pitchfork's methods regardless
                                        of the type of jazz the album is"),
                                 tags$h3("Metal"),
                                 tags$p("Metal has gotten better as the years have gone by. In the early 2000's Metal consistently scored below 6.5 but 
                                        as the years went by Metal Music rose and now is approaching the 8.0+ range."),
                                 tags$h3("Pop and R&B"),
                                 tags$p("Pop [and R&B] is reflective of its genre: Popular music. It has never scored below a 6.0 within the last 18 years, 
                                        but it's also only scored above \"good\" (defined by the average of all reviews) once in that same time frame. 
                                        The dip in 2017 can also be accounted for by the fact that Pitchfork hadn't reviewed any Pop/R&B albums by January 2017."),
                                 tags$h3("Rap"),
                                 tags$p("\"Gangsta rap is dead\" - A lot of oldheads, but they have a point. Average rap album scores peaked in 1999 at 8.6 and has 
                                         only gone down since then. The latest average in 2017 is a staggering 5.89. Kendrick, Kanye, and Run The Jewels can't 
                                         seem to make up for the impact that Nas, NWA, GFK made in the early 2000's. Especially with popular artists like Tory Lanez, 
                                         Tyga, and Yung Lean scoring below 4.0."),
                                 tags$h3("Rock"),
                                 tags$p("Rock is almost as varied as Experimental music. Between 1999 and 2016 it's consistently scored within a 0.5 range between 
                                        7.2 and 6.7. This is despite artists like The National, Bon Iver, and Beach House consistently putting out 9.0+ albums"))
                     )
                  )
               )
      ),# End of tabPanel 3
      # Table to answer question 4
      # 
      tabPanel("Specific Artist",
               titlePanel("Do album ratings change with more albums released?"),
               sidebarLayout(
                  sidebarPanel(
                     textInput("uq_search", label = h4("Search for Artist"), value = "Enter artist...")
                  ),
                  mainPanel(
                     tabsetPanel(
                        tabPanel("Table", tableOutput("plot_4"),
                                 tags$br(),
                                 tags$p("Type in an artist's name to get information on their albums. The information will be in a table containing the artist's
                                        name, their album, their album's score, the year in which it was reviewed, and their ranking amongst all of the reviews
                                        within the dataset. The name does not need to be properly capitalized but the spelling needs to be correct (Beyonce's
                                        name needs to have the accute accent over the last e")
                                 ),
                        tabPanel("Explanation",
                                 tags$br(),
                                 tags$p("We questioned whether or not ratings changed as an artist released more albums (if they got better, worse
                                        or stayed consistent). We created this visualization for interactivity because we obviously can't encompass
                                        every single artist (over 10,000+). A user can look up their own artist to test and analyze a specific case
                                        of how ratings changed over time."),
                                 tags$h3("More albums"),
                                 tags$p("In terms of our research, when an artist produces more albums, the scores tend to increase with every new
                                        one. This might be due to how success breeds success, and how constant bad scores can kill an artist's career.
                                        In our case we looked at Prince, The National, and Kanye West"),
                                 tags$h3("Less Albums"),
                                 tags$p("We also looked at artists who seldomly release albums to see how they score and our finding was that they can
                                        either do very well or very poorly. In our cases we looked at Frank Ocean, Black Kids, and Neutral Milk Hotel")
                                 )
                     )
                  )
               )
      ), # End of tabPanel 4
      tabPanel("Conclusions",
               mainPanel(
                  tags$div(
                  # Question 1
                     tags$h2("Is there a correlation or  bias of how an album scores due to its genre?"),
                     tags$p("Here we analyzed the bias of PitchFork reviews regarding genre. We questioned whether there was any sort of indication as to the type of genre the writers for 
                           PitchFork preferred. We found that rock was the genre that produced the most perfect scores, but it also was the genre with most 0 scoring albums. Pop/R&B 
                           followed rock with the second highest amount of 10 scoring albums, and had an average score of 6.8 overall, the lowest average of all the genres, whereas 
                           rock had an average score of 6.9. The genre with highest average score was global with an average of 7.4. This shows that PitchFork writers more consistently 
                           score global music higher than other genres such as pop and R&B."),
                     
                  # Question 2
                     tags$h2("Does being a part of a big(ger) record label correlate in an artist producing higher \"quality\" albums?"),
                     tags$p("Here we analyzed whether an album produced by a big label would have on average, higher scores than albums produced by independent labels, or labels that had 
                           not produced as many albums. We defined label size by figuring out the number of albums any one record label had produced. We found that being a part of a 
                           big label did not correlate to higher scores. While smaller record labels did have albums that scored lower than bigger record labels, they also had albums 
                           that scored equivalent high scores to the bigger record labels. This shows that there is no direct correlation between record label size and average score 
                           of the album produced."),
                     
                  # Question 3
                     tags$h2("How have reviews for a specific genre changed over time: are some genres \"timeless\" as they are toted to be?"),
                     tags$h4("Electronic"),
                     tags$p("Average scores have increased over time, but they did hav a dip during the punk/scene/goth rock era 
                                        during th early-mid 2000's, but has become better recently. This is likely due to artist's 
                                        like Diplo, Deadmau5, and Zedd emerging."),
                     tags$h4("Experimental"),
                     tags$p("Average scores have been all over the place, reminiscent of the genre name. Experimental music has never scored above 
                                        7.75/10.0 but it's been consistently above 7.0 since 2000. It's seems to vary within 7.0 - 7.75"),
                     tags$h4("Folk/Country"),
                     tags$p("Folk/Country scores have been very consistent throughout the years. It is consistently scoring in the 7-7.5  range
                                       (note: the dip in 2017 is due to the reviews being from 1999 - January 2017, 
                                        and can be accounted for by a lack of reviews of Folk and Country music in January 2017)."),
                     tags$h4("Global (international music)"),
                     tags$p("Global music has been consistently better than average, with averages of 8.0+ scores; 
                                       their dip in 2017 can also be accounted for due to Pitchfork not having reviewed any global albums in Jan, 2017."),
                     tags$h4("Jazz"),
                     tags$p("This genre has only dipped below 7.0 once in the last 18 years (2017 is due to no jazz reviews in January).
                                        Jazz is a niche genre that is hard to judge but this data shows consistency in Pitchfork's methods regardless
                                        of the type of jazz the album is"),
                     tags$h4("Metal"),
                     tags$p("Metal has gotten better as the years have gone by. In the early 2000's Metal consistently scored below 6.5 but 
                                        as the years went by Metal Music rose and now is approaching the 8.0+ range."),
                     tags$h4("Pop and R&B"),
                     tags$p("Pop [and R&B] is reflective of its genre: Popular music. It has never scored below a 6.0 within the last 18 years, 
                                        but it's also only scored above \"good\" (defined by the average of all reviews) once in that same time frame. 
                                        The dip in 2017 can also be accounted for by the fact that Pitchfork hadn't reviewed any Pop/R&B albums by January 2017."),
                     tags$h4("Rap"),
                     tags$p("\"Gangsta rap is dead\" - A lot of oldheads, but they have a point. Average rap album scores peaked in 1999 at 8.6 and has 
                                         only gone down since then. The latest average in 2017 is a staggering 5.89. Kendrick, Kanye, and Run The Jewels can't 
                                         seem to make up for the impact that Nas, NWA, GFK made in the early 2000's. Especially with popular artists like Tory Lanez, 
                                         Tyga, and Yung Lean scoring below 4.0."),
                     tags$h4("Rock"),
                     tags$p("Rock is almost as varied as Experimental music. Between 1999 and 2016 it's consistently scored within a 0.5 range between 
                                        7.2 and 6.7. This is despite artists like The National, Bon Iver, and Beach House consistently putting out 9.0+ albums"),
                  # Question 4
                     tags$h2("How has the popularity and quality of an artists' work changed over time?"),
                     tags$p("We questioned whether or not ratings changed as an artist released more albums (if they got better, worse
                                        or stayed consistent). We created this visualization for interactivity because we obviously can't encompass
                                        every single artist (over 10,000+). A user can look up their own artist to test and analyze a specific case
                                        of how ratings changed over time."),
                     tags$h4("More albums"),
                     tags$p("In terms of our research, when an artist produces more albums, the scores tend to increase with every new
                                        one. This might be due to how success breeds success, and how constant bad scores can kill an artist's career.
                                        In our case we looked at Prince, The National, and Kanye West"),
                     tags$h4("Less Albums"),
                     tags$p("We also looked at artists who seldomly release albums to see how they score and our finding was that they can
                                        either do very well or very poorly. In our cases we looked at Frank Ocean, Black Kids, and Neutral Milk Hotel")
                  ),
                  tags$div(
                     tags$h3("Conclusion"),
                     tags$p("After analyzing this dataset on albums and their reviews, we found that music reviews are extremely varied, and trends are constantly
                            shifting. What dictates a good review might not necessarily mean that the album is enjoyable for everyone. Music taste is
                            very subjective and personal, and so people shouldn't use reviews to validate their opinion because at the end of the day, reviews are
                            opinions. However, comparing reviews to your own opinions is definitely interesting and fun, and reviews can definitely help you find
                            new music that you wouldn't have ever thought of listening to.")
                  )
               )
      ) # End of tabPanel 5
   ) # End of navbarPage
)

shinyUI(my_ui)
