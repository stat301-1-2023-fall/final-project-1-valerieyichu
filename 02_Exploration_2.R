
## Set Up

## Load Packages -----

library(tidyverse)




## Load Data -----

books <- read_delim("data/books.csv")
books_tags <- read_csv("data/book_tags.csv")
ratings <- read_csv("data/ratings.csv")
tags <- read_csv("data/tags.csv")
tbr <- read_csv("data/to_read.csv")
books_and_tags <- read_rds("data/books_and_tags.rds")
books_and_ratings <- read_rds("data/books_and_ratings.rds")




## Exploration 2, Part 1 -----

# What are the most popular tags?
popular_tags <- books_and_tags |> 
  group_by(tag_name) |> 
  summarize(tags = n()) |> 
  filter(tags > 1000) |> 
  arrange(desc(tags)) |> 
  DT::datatable()

popular_tags




## Exploration 2, Part 2 -----

# Which are the highest rated young adult (YA) books?

# Which books have a tag_name "ya"? 
books_and_tags_ya <- books_and_tags |> 
  filter(str_detect(tag_name, "^ya"))

books_and_tags_ya


# Reminder: The "books_and_tags" joined the "books_tags" dataset and the "tags" dataset. 
# It hasn't yet matched "goodreads_book_id" with its title. So let's get the title. 
books_and_tags_ya_new <- full_join(books_and_tags_ya, books, join_by(goodreads_book_id == goodreads_book_id))

books_and_tags_ya_new


# 100 Most Highly Rated YA Books
books_and_tags_ya_new |> 
  arrange(desc(average_rating)) |> 
  select(goodreads_book_id, tag_name, title, authors, average_rating, ratings_count) |> 
  slice_head(n = 100) |> 
  DT::datatable()




## Exploration 2, Part 3 -----

# What years were young adult (YA) books published in?

# An exploration of the variable `original_publication_year`
books_and_tags_ya_new |> 
  ggplot(aes(x = original_publication_year)) +
  geom_boxplot() +
  scale_x_continuous(breaks = seq(-2000, 2500, by = 500)) +
  theme_bw() +
  labs(
    title = "What years were young adult books published in?",
    subtitle = "Most YA books were published after the year 2000, but there are a few ancient ones.",
    x = "Original Publication Year", 
    y = NULL) 



## Exploration 2, Part 4 -----

# Which YA books have more ratings?
  
books_and_tags_ya_new |> 
  ggplot(aes(x = original_publication_year, y = ratings_count)) +
  geom_point(alpha = 0.1) +
  scale_x_continuous(expand = c(0.1, 0.9), breaks = seq(-2000, 2500, by = 500)) +
  theme_bw() +
  labs(
    title = "How does the year a young adult book was \npublished affect its number of Goodreads ratings?",
    subtitle = "YA books published after 1750 have more ratings on Goodreads.",
    x = "Original Publication Year", 
    y = "Number of Ratings") +
  theme(plot.title = element_text(size = 20))




