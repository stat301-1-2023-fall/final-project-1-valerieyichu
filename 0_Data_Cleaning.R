
## Set Up

## Load Packages -----

library(tidyverse)



## Load Data -----

books <- read_delim("data/books.csv")
books_tags <- read_csv("data/book_tags.csv")
ratings <- read_csv("data/ratings.csv")
tags <- read_csv("data/tags.csv")
tbr <- read_csv("data/to_read.csv")








## NOTE - REFER TO THE qmd "1_Joining_Datasets" FOR A MORE IN-DEPTH EXPLANATION OF THIS PART
# I made it a qmd because there was a lot of writing involved. 









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

# Print an excerpt of the new dataset
# **The new books_and_tags dataset** (The first 10 of 999,912 rows.)
books_and_tags |> 
  slice_head(n = 10) |> 
  knitr::kable()


# Write the dataset
write_rds(books_and_tags, "data/books_and_tags.rds")




## Step 2: Joining books and ratings -----

# The place where I got my dataset noted that `book_id` in "ratings" and "tbr" maps to `work_id`.
# So I tried to join the datasets that way and decided that ultimately, I'm not going to do that. 
# This is why.

# This is a bit of a detour and hard to explain without showing my code, 
# so I'm not including this part in the qmd, but I'm going to write it here because it's interesting. 

# Antijoins using work_id and book_id don't quite fit together
anti_join(books, ratings, by = c("work_id" = "book_id"))
anti_join(ratings, books, by = c("book_id" = "work_id"))

# Interestingly, the first antijoin using work_id and book_id reveal that there are 9,824 rows missing. 
# The second antijoin using book_id and work_id reveal that there are 5,846,293 rows missing. 
# So that means that `book_id` from rating and `work_id` from books don't quite match. 
# **That's probably because of all the additional book editions that joining with `work_id` uses.** 
# As the original dataset noted, 
  # Each book may have many editions. 
  # goodreads_book_id and best_book_id generally point to the most popular edition of a given book, 
  # while goodreads work_id refers to the book in the abstract sense.
# So instead, since I only care about the most popular edition of a given book and not all the editions aggregated, 
# I'm going to join book_id to book_id:

anti_join(books, ratings, by = c("book_id" = "book_id"))

# Joining the datasets
books_and_ratings <- full_join(books, ratings, join_by(book_id == book_id)) 

# Write the dataset
write_rds(books_and_ratings, "data/books_and_ratings.rds")



