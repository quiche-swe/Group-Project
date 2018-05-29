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
unique_albums <- select(unique_albums, rank, score, artist, title, genre)
