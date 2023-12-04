
### Progress Memo 2 -----

## The Instructions -----
    # Basic objectives
    # Objective 1
    # Students are expected to setup their own qmd file to render to an html for this project. 
      # The document should be appropriately formatted (see previous memo and other assignments). 
      # Should have a title, author, date, and appropriate headers, and sub-headers.
    
    # Objective 2
    # Students are expected to demonstrate that significant progress has been made 
      # on their final project since the submission of progress memo 1. 
    # Students should have their data cleaned and the EDA should be started.
    
    # Demonstrating significant progress means students should have some 
      # univariate and bivariate analyses complete for several of their variables.
    # They should share a few graphics and/or tables with a description of what they 
      # have found thus far to demonstrate they progress. 
    # Students should should clearly state what they are exploring and why in these demonstrations. 
    # That is, they should share the guiding curiosity or research question 
      # that accompanies the particular graphics and/or tables they choose to share. 
    
    # What else should be in the memo
    # Students should summarize their progress, where they are at, and what their next steps will be. 
    # Self assessment of progress would also be appropriate. 
    # When thinking or describing next steps students should share 
      # any guiding curiosities or research questions they plan to explore.
    
    # Misc Notes/Comments
    # Final GitHub repo link should be at the top in a callout block --- 
      # similar to all other assignments
    # There should be no code visible or accessible in memo. 
    # There should be no raw R output like tibbles/data frames. Use html tables.
    # In rare cases where the the project is extremely heavy on 
      # advanced data collection, progress will look quite different. 
    # Projects like this will be focused on showing progress on getting the data 
      # together and collected. 
    # If your project falls in this category, then discuss this with your instructor
      # --- very few, if any projects, fall into this rare case. 

  ## Notes from Class
          # # SCRATCH WORK IGNORE BELOW
          # 
          # **Data should be merged, cleaned, and variables should be explored. Univariate and bivariate analysis completed for several variables.** 
          #   If your tibble is particularly big, put an appendix. Or if you have miscellaneous information that's not that important but that you really want to show, put it in an appendix. 
          # 
          # Either use ggsave or echo false. 
          # 
          # 
          # ## Load Data
          # ```{r}
          # library(tidyverse)
          # ```
          # 
          # 
          # 
          # After you do all this data cleaning, save it as an RDS to preserve variable types!! That way you can read it in again with each script. 
          # 
          # Here's a demo of what it could look like:
          #   ```{r}
          # #| echo: false
          # 
          # tibble <- tibble(name = c("var1") , value = c(1))
          # 
          # tibble |> 
          #   knitr::kable()
          # 
          # ```
          # 
          # Don't show a skim or a summary output. INSTEAD, make it look nice. 
          # 
          # - Ex. Calculate summary stats with summarize() to output as a nice table. Mean, sd, correlation, etc. 
          # 
          # - Ex. Make a scatterplot, a boxplot, etc. 




## Starting the project -----


## Load Packages -----

library(tidyverse)




## Load Data -----

books <- read_delim("data/books.csv")
books_tags <- read_csv("data/book_tags.csv")
ratings <- read_csv("data/ratings.csv")
tags <- read_csv("data/tags.csv")
tbr <- read_csv("data/to_read.csv")




# Questions, note to self
# - How do users tag the most highly rated books? Is there a trend?
#  grouping the different ratings (if treating rating as a category) --> stacked barplot, etc. 




## Step 1: Joining tags and book_tags -----

# tags.csv and books_tags.csv both have the variable `tag_id` in common. 
# And `tag_id` has only unique values for both datasets. 
# `tag_id` also corresponds for both datasets. 
# So let's test whether `tag_id` is a feasible foreign / primary key:

anti_join(tags, books_tags, by = c("tag_id" = "tag_id"))  

anti_join(books_tags, tags, by = c("tag_id" = "tag_id")) 

books_tags |> count(tag_id)
tags |> count(tag_id)


# tag_id is a primary key for both datasets and a foreign key

# Joining the datasets

books_and_tags <- full_join(tags, books_tags, join_by(tag_id == tag_id))

books_and_tags



## Step 2: Joining books and ratings -----


# This is a bit of a detour and hard to explain without showing my code, 
# so I'm not including this part in the qmd, but I'm going to write it here because it's interesting. 

# Antijoins using work_id and book_id don't quite fit together
anti_join(books, ratings, by = c("work_id" = "book_id"))
anti_join(ratings, books, by = c("book_id" = "work_id"))

# Interestingly, the first antijoin using work_id and book_id reveal that there are 9,824 rows missing. 
# The second antijoin using book_id and work_id reveal that there are 5,846,293 rows missing. 
# So that means that `book_id` from rating and `work_id` from books don't quite match. 
# **That's probably because of all the additional book editions that joining with `work_id` uses.** 
# So instead, since I only care about the most popular edition of a given book and not all the editions aggregated, 
# I'm going to join book_id to book_id:

anti_join(books, ratings, by = c("book_id" = "book_id"))


# Back to the qmd work

# Some Office Hours Advice:
  # Let's use full_join then filter for NA values. 
  # 
  # full join includes books that don't have a rating and ratings that aren't paired with books.
  # So instead maybe - summarize ratings by books then join them
  # left join books
  # 
  # 0. missingness .merge issues. summary statistics. weird things happening/outliers to deal with/unusual things.
  # 1. make sure factors are factors, characters are characters, etc. 
  # 3. Research questions
  # 
  # 
  # 1. condense ratings into summarized outputs. 
  # 2. mess around with the order of the left join. 

# Out of curiosity; not included in the qmd; joining work_id by book_id
books_and_ratings <- full_join(books, ratings, join_by(work_id == book_id)) |> 
  select(title, work_id, book_id) 

books_and_ratings 


# Joining book_id by book_id

books_and_ratings <- full_join(books, ratings, join_by(book_id == book_id)) |> 
  group_by(title) |> 
  select(title, book_id, goodreads_book_id, work_id, user_id, rating)

books_and_ratings


## Question 1: Which are the most highly rated books? -----

# 10 Books with the Highest Average Goodreads Rating
books |> 
  arrange(desc(average_rating)) |> 
  select(book_id, title, authors, average_rating, ratings_count) |> 
  slice_head(n = 10) |> 
  DT::datatable()


# Start by creating a new variable, rank_of_number_ratings, that assigns each book a rank based on how high their ratings_count is. 
# In other words, more ratings = higher rank. 

rank_ratings <- function(books, ratings_count) {
  books %>%
    arrange(desc({{ ratings_count }})) %>%
    mutate(rank_of_number_ratings = row_number())
}

rank_ratings <- rank_ratings(books, ratings_count)

# rank_ratings contains everything inside the books dataset, plus the rank_of_number_ratings




# Create a line graph to show how the average rating changes as the rank of the number of ratings changes
rank_ratings |> 
  ggplot(aes(x = rank_of_number_ratings, y = average_rating)) +
  geom_line() +
  labs(
    title = "Average Rating vs. Ratings Place",
    subtitle = "There is no relationship between a book's average rating and the number of ratings it received.",
    x = "Books ranked by the number of ratings it got. (1 = Most ratings, 10000 = Least ratings)", 
    y = "Average Rating")

# Actually, a scatterplot is better. The data is so dense that a line graph adds too much noise. 
rank_ratings |> 
  ggplot(aes(x = rank_of_number_ratings, y = average_rating)) +
  geom_point() +
  labs(
    title = "Average Rating vs. Ratings Place",
    subtitle = "There is no relationship between a book's average rating and the number of ratings it received.",
    x = "Books ranked by the number of ratings it got. (1 = Most ratings, 10000 = Least ratings)", 
    y = "Average Rating")



# Correlation

corr <- rank_ratings |> 
  select(average_rating, rank_of_number_ratings) |> 
  cor() |> 
  knitr::kable()

corr




## Cut -----

# So, technically, a histogram works fine

books |> 
  ggplot(aes(x = average_rating)) +
  geom_histogram(binwidth = 0.25, color = "white") +
  scale_x_continuous(breaks = pretty(c(0,5), n = 10)) 

# But a histogram isn't that easy to read. It would be easier to create bins that ratings fall within. 
# Hence, let's use cut.


# Try 1
books_cut <- rank_ratings |> 
  mutate(average_rating_cut = cut(average_rating, 
                                  breaks = c(0, 1, 2, 3, 4, 5, 6))) |> 
  select(title, average_rating, average_rating_cut)

books_cut

books_cut |> 
  ggplot(aes(x = average_rating_cut)) +
  geom_bar()


# Not varied enough. Let's make the cuts in books_cut smaller

# Cut average_rating into bins of 0.25
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

# First, a quick look at how many books are in each bin.
books_cut |> 
  count(average_rating_cut) |> 
  knitr::kable()


# Create Bar Plot
books_cut |> 
  ggplot(aes(x = average_rating_cut)) +
  geom_bar() +
  labs(title = "The Distribution of the Average Rating of Books",
       x = "Average Rating",
       y = "Number of Books")


## Question 2 -----

books_and_ratings |> 
  group_by(user_id) |> 
  summarize(count = n()) |> 
  arrange(desc(count))

# Now, let's see what the average ratings of these top book-rating users is. 

# Still in progress: 
# Finish in final project:
# for (i in unique(user_id)) {
#   
#   if (user_id = 1) {
#     rating = 
#   }
#   user_ratings <- 
#     
# }
# rank_ratings <- function(books, ratings_count) {
#   books %>%
#     arrange(desc({{ ratings_count }})) %>%
#     mutate(rank_of_number_ratings = row_number())
# }
# 
# rank_ratings <- rank_ratings(books, ratings_count)

books_and_ratings |> 
  group_by(user_id) |> 
  mutate(average_rating = (mean(rating, na.rm = TRUE)))


