
### Progress Memo 2 -----

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


## Starting the project -----


## Load Packages -----

library(tidyverse)




## Load Data -----

books <- read_delim("data/books.csv")
books_tags <- read_csv("data/book_tags.csv")
ratings <- read_csv("data/ratings.csv")
tags <- read_csv("data/tags.csv")
tbr <- read_csv("data/to_read.csv")




## Joining Datasets -----

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




books_and_ratings <- full_join(books, ratings, join_by(work_id == book_id)) |> 
  select(title, work_id, book_id) 

books_and_ratings 



