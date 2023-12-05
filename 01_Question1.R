
## Set Up

## Load Packages -----

library(tidyverse)




## Load Data -----

books <- read_delim("data/books.csv")
books_tags <- read_csv("data/book_tags.csv")
ratings <- read_csv("data/ratings.csv")
tags <- read_csv("data/tags.csv")
tbr <- read_csv("data/to_read.csv")
books_and_tags <- read_rds("data/books_and_tags.csv")
books_and_ratings <- read_rds("data/books_and_ratings.csv")




## Exploration 1 Part 1 -----
# Question 1, Part 1: Which 10 books have the highest average Goodreads rating?
# 10 Books with the Highest Average Goodreads Rating

books |> 
  arrange(desc(average_rating)) |> 
  select(book_id, title, authors, average_rating, ratings_count) |> 
  slice_head(n = 10) |> 
  DT::datatable()




## Exploration 1 Part 2 -----
# Question 1, Part 2: Is there a relationship between the rank a book receives 
# based on its number of ratings and its average rating?

# Start by creating a new variable, rank_of_number_ratings, 
# that assigns each book a rank based on how high their ratings_count is. 
# In other words, more ratings = higher rank. 
rank_ratings <- function(books, ratings_count) {
  books %>%
    arrange(desc({{ ratings_count }})) %>%
    mutate(rank_of_number_ratings = row_number())
}

rank_ratings <- rank_ratings(books, ratings_count)
# rank_ratings contains everything inside the books dataset, plus the variable `rank_of_number_ratings`


# Create a scatterplot to show how the average rating changes as the rank of the number of ratings changes
rank_ratings |> 
  ggplot(aes(x = rank_of_number_ratings, y = average_rating, color = language_code)) +
  geom_point(alpha = 0.1) +
  labs(
    title = "Average Rating vs. Ratings Place",
    subtitle = "There is no relationship between a book's average rating and the number of ratings it received.",
    x = "Books ranked by the number of ratings it got (1 = Most ratings, 10000 = Least ratings)", 
    y = "Average Rating",
    color = "Language Code") +
  theme_bw()


# Correlation plot
corr <- rank_ratings |> 
  select(average_rating, rank_of_number_ratings) |> 
  cor() |> 
  knitr::kable()

corr



## Exploration 1 Part 3 -----
# So, how many books and what percent of books on Goodreads are written in English?
rank_ratings_summary <- rank_ratings |> 
  group_by(language_code) |> 
  summarize(count = n()) 


rank_ratings_prop <- rank_ratings_summary |> 
  mutate(percent = count / sum(count) * 100)

rank_ratings_prop <- rank_ratings_prop %>%
  mutate(language_code = coalesce(language_code, "other"))

colnames(rank_ratings_prop) <- c("Language Code", "Count", "Percent")

rank_ratings_prop |> 
  DT::datatable()




## Exploration 1 Part 4 -----
# What's the distribution of book ratings?

# Now let's look at the distribution of book ratings.

# A histogram, possibly? 
  books |> 
    ggplot(aes(x = average_rating)) +
    geom_histogram(binwidth = 0.25, color = "white") +
    scale_x_continuous(breaks = pretty(c(0,5), n = 10)) 

# No. Technically, a histogram is fine. 
  # (See above for an example that I didn't include here because it's not that relevant.) 
  # But even when I use `pretty` and break the x-axis into measurements that are easy to read, 
  # it's still not that intuitive to read. 
  # Because when I look at a Goodreads rating, I don't think of the rating scale as continuous. 
  # I think of them in bins of 0.25. 
  # For example, a book with ≥ 4.5 ratings is excellent. 
  # A book with ≥ 4.75 is practically unheard of. 
  # And a book with a rating between 4.0 and 4.25 is great. 
  # So that's why I'm going to use `cut` to create bins that are intuitive to think about.

# Put average_rating into bins of 0.25. 
books_cut <- rank_ratings |> 
  mutate(average_rating_cut = cut(average_rating, 
                                  breaks = c(0, 0.25, 0.5, 0.75,
                                             1, 1.25, 1.5, 1.75,
                                             2, 2.25, 2.5, 2.75,
                                             3, 3.25, 3.5, 3.75, 
                                             4, 4.25, 4.5, 4.75, 
                                             5))) |> 
  select(title, average_rating, average_rating_cut)

books_cut


# Distribution of Book Ratings
books_count <- books_cut |> 
  count(average_rating_cut) 

colnames(books_count) <- c("Average Rating", "Number of Books")

books_count |>
  knitr::kable()


# Barplot: The Distribution of the Average Rating of Books on Goodreads
books_cut |> 
  ggplot(aes(x = average_rating_cut)) +
  geom_bar() +
  labs(title = "The Distribution of the Average Rating of Books on Goodreads",
       x = "Average Rating",
       y = "Number of Books") +
  theme_bw()



