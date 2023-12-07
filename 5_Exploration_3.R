
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




## Question 2, Part 1 -----

# Grouping by user_id and counting that number tells us the users who rate the most books on Goodreads. `count` is the number of books the user has rated. If we also keep in mind that this dataset only has the data of the 10k most rated books on Goodreads, having users who rated 200 books (as a few book-rating users have done) is quite impressive.

books_and_ratings |> 
  group_by(user_id) |> 
  summarize(count = n()) |> 
  arrange(desc(count)) |> 
  slice_head(n = 10) |> 
  knitr::kable()



## Question 2, Part 2 -----

# Now, let's see what the average ratings of these top book-rating users is. 
books_and_ratings <- books_and_ratings |> 
  group_by(user_id) |> 
  mutate(average_rating = (mean(rating, na.rm = TRUE))) 


# We just added a new variable, `average_rating` to the "books_and_ratings" dataset. 
# `average_rating` shows the average rating of each user.
# However, there are 5976497 observations in our "books_and_ratings" dataset, and my computer crashes if I try to plot all those points. 
# Besides, I'm interested in the users who leave the most number of ratings anways. 
# As the table above shows, the users who left the most ratings left 200 ratings. So let's use filter to keep only the users who rated more than 175 books. 

# Users who rated more than 175 books
books_and_ratings_top_raters <- books_and_ratings |> 
  group_by(user_id) |> 
  mutate(count = n()) |> 
  filter(count > 175)


# Creating a new variable, `id`, that gives each top rater a id. The more books rated, the higher the id. 
books_and_ratings_top_raters_id <- books_and_ratings_top_raters |> 
  arrange(desc(count)) |> 
  mutate(id = row_number())

books_and_ratings_top_raters_id


books_and_ratings_final |> 
  ggplot(aes(x = id, y = average_rating, color = count_cut)) +
  geom_col() +
  # facet_wrap(~ count_cut, scales = "free_y") +
  #  geom_point() +
  #  geom_smooth(alpha = 0.25) +
  #  scale_x_continuous(breaks = seq(0, 60000, by = 10000)) +
  #  ylim(c(0, 5)) +
  #  scale_y_continuous(breaks = seq(0, 5, by = 0.5)) +
  theme_bw() +
  labs(
    title = "Do Top Raters Give Higher Or Lower Average Ratings?",
    subtitle = "Top raters tend to give slightly lower average ratings than those who rate less books.",
    x = "User Rank (by number of books rated)", 
    y = "Average Rating (1-5 stars)",
    color = "Books Rated")




## Question 2, Part 3 -----



