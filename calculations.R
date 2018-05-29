library(dplyr)

artists <- read.csv(file = "data/artists.csv", stringsAsFactors = FALSE)
genres <- read.csv(file = "data/genres.csv", stringsAsFactors = FALSE)
labels <- read.csv(file = "data/labels.csv", stringsAsFactors = FALSE)
reviews <- read.csv(file = "data/reviews.csv", stringsAsFactors = FALSE)
years <- read.csv(file = "data/years.csv", stringsAsFactors = FALSE)

cleaned_reviews <- select(reviews, reviewid, title, artist, score, best_new_music, pub_month, pub_year)
cleaned_reviews <- left_join(genres, cleaned_reviews)
cleaned_reviews <- left_join(labels, cleaned_reviews)
years <- left_join(years, artists)
perfect_albums <- filter(cleaned_reviews, score == 10.0)
bad_albums <- filter(cleaned_reviews, score == 0.0)
cleaned_reviews$genre_occurrences <- table(cleaned_reviews$genre)[cleaned_reviews$genre]
cleaned_reviews$albums_label_produced <- table(cleaned_reviews$label)[cleaned_reviews$label]

# Unique album reviews with rank column
unique_albums <- subset(cleaned_reviews, !duplicated(cleaned_reviews$reviewid, incomparables = FALSE))
albums_score <- order(-unique_albums$score, unique_albums$title)
unique_albums$rank <- NA
unique_albums$rank[albums_score] <- 1:nrow(unique_albums)

# Median and mean scores
median_score <- summarize(cleaned_reviews, median_score = median(score))
mean_score <- summarize(cleaned_reviews, mean_score = mean(score))
# NOTE: If you want to use mean_score and median_score then you need to use
# as.numeric(mean_score) because mean_score is of object type list 

# dataframes of each unique genre
rock_music <- filter(cleaned_reviews, genre == "rock")
electronic_music <- filter(cleaned_reviews, genre == "electronic")
metal_music <- filter(cleaned_reviews, genre == "metal")
undefined_music <- filter(cleaned_reviews, genre == "")
rap_music <- filter(cleaned_reviews, genre == "rap")
experimental_music <- filter(cleaned_reviews, genre == "experimental")
pop_rb_music <- filter(cleaned_reviews, genre == "pop/r&b")
folk_country_music <- filter(cleaned_reviews, genre == "folk/country")
jazz_music <- filter(cleaned_reviews, genre == "jazz")
global_music <- filter(cleaned_reviews, genre == "global")

# Number of genres in total reviews and perfect reviews
total_genres <- length(unique(cleaned_reviews[["genre"]]))
total_artists <- length(unique(cleaned_reviews[["artist"]]))
perfect_artists <- length(unique(perfect_albums[["artist"]]))

# Unique genres in total reviews and perfect reviews
total_genres <- as.character(unique(unlist(cleaned_reviews$genre)))
perfect_genres <- as.character(unique(unlist(perfect_albums$genre)))

# How many of each genre has recieved a 10.0 score
perfect_rock_sum <- summarize(perfect_albums, sum = sum(genre == "rock"))
perfect_experimental_sum <- summarize(perfect_albums, sum = sum(genre == "experimental"))
perfect_pop_rb_sum <- summarize(perfect_albums, sum = sum(genre == "pop/r&b"))
perfect_jazz_sum <- summarize(perfect_albums, sum = sum(genre == "jazz"))
perfect_rap_sum <- summarize(perfect_albums, sum = sum(genre == "rap"))
perfect_electronic_sum <- summarize(perfect_albums, sum = sum(genre == "electronic"))
perfect_undefined_sum <- summarize(perfect_albums, sum = sum(genre == ""))
perfect_folk_country <- summarize(perfect_albums, sum = sum(genre == "folk/country"))

# How successful genres are in terms of scoring 10's
ten_rate <- nrow(perfect_albums) / nrow(cleaned_reviews) * 100

rock_ten_rate <- (perfect_rock_sum / nrow(rock_music)) * 100
experimental_ten_rate <- (perfect_experimental_sum / nrow(experimental_music)) * 100
pop_rb_ten_rate <- (perfect_pop_rb_sum / nrow(pop_rb_music)) * 100
jazz_ten_rate <- (perfect_jazz_sum / nrow(jazz_music)) * 100
rap_ten_rate <- (perfect_rap_sum / nrow(rap_music)) * 100
electronic_ten_rate <- (perfect_electronic_sum / nrow(electronic_music)) * 100
undefined_ten_rate <- (perfect_undefined_sum / nrow(undefined_music)) * 100
folk_country_ten_rate <- (perfect_folk_country / nrow(folk_country_music)) * 100
metal_ten_rate <- 0.000
global_ten_rate <- 0.000

# Best new music
best_new_music <- filter(cleaned_reviews, best_new_music == "1")
new_rock_sum <- summarize(best_new_music, sum = sum(genre == "rock"))
new_rap_sum <- summarize(best_new_music, sum = sum(genre == "rap"))
new_jazz_sum <- summarize(best_new_music, sum = sum(genre == "jazz"))
new_undefined_sum <- summarize(best_new_music, sum = sum(genre == ""))
new_electronic_sum <- summarize(best_new_music, sum = sum(genre == "electronic"))
new_experimental_sum <- summarize(best_new_music, sum = sum(genre == "experimental"))
new_pop_rb_sum <- summarize(best_new_music, sum = sum(genre == "pop/r&b"))
new_folk_country_sum <- summarize(best_new_music, sum = sum(genre == "folk/country"))
new_global_sum <- summarize(best_new_music, sum = sum(genre == "global"))
new_metal_sum <- summarize(best_new_music, sum = sum(genre == "metal"))

# How successful genres are in terms of getting rewarded best new music
new_rock_rate <- (new_rock_sum / nrow(rock_music)) * 100
new_rap_rate <- (new_rap_sum / nrow(rap_music)) * 100
new_jazz_rate <- (new_jazz_sum / nrow(jazz_music)) * 100
new_undefined_rate <- (new_undefined_sum / nrow(undefined_music)) * 100
new_electronic_rate <- (new_electronic_sum / nrow(electronic_music)) * 100
new_experimental_rate <- (new_experimental_sum / nrow(experimental_music)) * 100
new_pop_rb_rate <- (new_pop_rb_sum / nrow(pop_rb_music)) * 100
new_folk_country_rate <- (new_folk_country_sum / nrow(folk_country_music)) * 100
new_global_rate <- (new_global_sum / nrow(global_music)) * 100
new_metal_rate <- (new_metal_sum / nrow(metal_music)) * 100

# "Good" albums (albums that are scored better than average)
good_albums <- filter(cleaned_reviews, score > as.numeric(unlist(mean_score)))

# "Bad" albums (albums that scored lower than average)
bad_albums <- filter(cleaned_reviews, score < as.numeric(unlist(mean_score)))

# See how labels fare but keep the 
label_mean <- group_by_at(cleaned_reviews, vars(label, albums_label_produced)) %>%
   summarize(mean = mean(score))

# Labels that consistently produce quality albums
good_labels <- filter(label_mean, mean > as.numeric(unlist(mean_score)))

# Data frames of each genre but of scores that qualify as "good 
good_rock <- filter(good_labels, genre == "rock")
good_rap <- filter(good_labels, genre == "rap") 
good_jazz <- filter(good_labels, genre == "jazz")
good_undefined <- filter(good_labels, genre == "undefined")
good_electronic <- filter(good_labels, genre == "electronic")
good_experimental <- filter(good_labels, genre == "experimental")
ood_pop_rb <- filter(good_labels, genre == "pop_r&b")
good_folk_country <- filter(good_labels, genre == "folk_country"
good_global <- filter(good_labels, genre == "global")
good_metal <- filter(good_labels, genre == "metal")

# Labels that consistently produce bad albums
bad_labels <- filter(label_mean, mean < as.numeric(unlist(mean_score)))


