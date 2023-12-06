
## Set Up

## Load Packages -----

library(tidyverse)
library(naniar)




## Load Data -----

books <- read_delim("data/books.csv")
books_tags <- read_csv("data/book_tags.csv")
ratings <- read_csv("data/ratings.csv")
tags <- read_csv("data/tags.csv")
tbr <- read_csv("data/to_read.csv")
books_and_tags <- read_rds("data/books_and_tags.rds")
books_and_ratings <- read_rds("data/books_and_ratings.rds")


miss_var_summary(books)
# Missing values: language_code, isbn, isbn13, original_title, original_publication_year

miss_var_summary(books_tags)
# No missing values in any variable

miss_var_summary(ratings)
# No missing values in any variable

miss_var_summary(tags)
# No missing values in any variable

miss_var_summary(tbr)
# No missing values in any variable

miss_var_summary(books_and_tags)
# No missing values in any variable

miss_var_summary(books_and_ratings)
# Missing values: language_code, isbn, isbn13, original_title, original_publication_year

