# Info 201 Group Project | Pitchfork Music Reviews

## Overview
Pitchfork is a music-centered magazine, originally started in 1995 by Ryan Schreiber with a focus on reviewing new music. Since then it has grown to be one the world's most influential music magazines, up there with Billboard, Rollings Stone, and XXL. This data-set comes from Nolan Conway of kaggle who scraped over 18,000 music reviews from 1999 to January 2017. The data originally came as an sqlite database and was then exported as a .csv database via DB Browser. Music fans from all around can appreciate the sheer volume of album reviews.

## Data Features
Within the [SQLite] database are 6 data-sets: artists (a table of artist names and their unique review ID), content (the holistic review of the album), labels (a table of recording labels and their corresponding albums), reviews (a table containing scores and technical information), and years (a table containing the album years). We've exported the SQLite database to separate .csv files and aggregated the data to form one single dataset to draw from, comprised of:

  - Review ID of each unique review
  - Record label associated with the album that was reviewed
  - The genre of the album (decided by Pitchfork)
  - The title of the album that was reviewed
  - The artist of the album
  - The score that the album received (out of 10.0)
  - The year of review

## Questions Asked
  1. Is there a correlation or even bias of how an album scores due to its genre?
  2. Does being a part of a big(ger) record label correlate in an artist producing higher "quality" albums?
  3. How have reviews for a specific genre changed over time: are some genres as "timeless" as they are toted to be?
  4. How has the popularity and quality of an artists' work changed over time?

## Application
All of these questions can be answered on our shiny application, which can be visisted [here](https://vtquach.shinyapps.io/Pitchfork-Reviews/)

## Authors
Jensen Anderson, Corina Geier, Ellie Qian, and Vince Quach
