## 02- Question 2

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




## Exploration 1 Part 5 Section 1 -----


# Grouping by user_id and counting that number tells us the users who rate the most books on Goodreads. `count` is the number of books the user has rated. If we also keep in mind that this dataset only has the data of the 10k most rated books on Goodreads, having users who rated 200 books (as a few book-rating users have done) is quite impressive.

books_and_ratings_sliced <- books_and_ratings |> 
  group_by(user_id) |> 
  summarize(count = n()) |> 
  arrange(desc(count)) 


books_and_ratings_sliced |> 
  slice_head(n = 10) |> 
  knitr::kable()




## Exploration 1 Part 5 Section 2 -----

# Now, let's see what the average ratings of these top book-rating users is. 

books_and_ratings <- books_and_ratings |> 
  group_by(user_id) |> 
  mutate(average_rating = (mean(rating, na.rm = TRUE))) 




# Create a new dataset, "books_and_ratings_new" 
# Count the number of books each user rated.
# Show what each user's average rating was.
# And get rid of all duplicates. 
# This new dataset now only has 53,424 rows because there are that many Goodreads users who have rated at least one book in this dataset. 

books_and_ratings_new <- books_and_ratings |>
  group_by(user_id) |>
  mutate(count = n()) |>
  select(user_id, average_rating, count) |> 
  distinct(user_id, .keep_all = TRUE) 




# Creating a new variable, `id`, that gives each rater a id. The more books rated, the higher the id. 
books_and_ratings_new <- books_and_ratings_new |> 
  mutate(id = row_number(desc(count)))

# books_and_ratings_new




# Create the variable `count_cut` that takes each `count` and puts it into a bin.
# Create the variable `rating_cut` that takes each `average_rating` and puts it into a bin. 

books_and_ratings_new <- books_and_ratings_new |> 
  mutate(count_cut = cut(count, 
                         breaks = c(0, 25, 50, 75, 
                                    100, 125, 150, 175,
                                    200)),
         rating_cut = cut(average_rating, 
                          breaks = c(0, 1, 2, 3, 4, 5))) 

# books_and_ratings_new


books_and_ratings_new |> 
  ggplot(aes(x = id, y = average_rating, color = count_cut)) +
  geom_point(alpha = 0.1) +
  # facet_wrap(~ rating_cut, scales = "free_y") +
  theme_bw() +
  labs(
    title = "Do Top Raters Give Higher Or Lower Average Ratings?",
    subtitle = "Top raters tend to give slightly lower average ratings than those who rate less books.",
    x = "User Rank (by number of books rated)", 
    y = "Average Rating (1-5 stars)",
    color = "Books Rated")




