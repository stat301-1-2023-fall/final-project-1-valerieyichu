## Datasets

::: {.callout-tip icon="false"}
## My Data Source

[**https://github.com/zygmuntz/goodbooks-10k**](https://github.com/zygmuntz/goodbooks-10k)
:::

This is how Goodreads describes itself: “Goodreads is the world’s largest site for readers and book recommendations. Our mission is to help readers discover books they love and get more out of reading. Goodreads launched in January 2007.”

This dataset comes in five separate csv files: “books”, “books_tags”, “ratings”, “tags”, and “tbr”

They're all quite clean. Only "books" had missingness, but not too much. 

See "1_Joining_Datasets" for more details. 

I also completed two joins and saved these two new files as rds files. They're both in the data folder. 

- I joined "books_tags" and "tags" to create "books_and_tags".

- I joined "books" and "ratings" to create "books_and_ratings".

The "goodreads_codebook.csv" contains more information about specific variables and what they mean. 

These three links are also helpful for reference:

- The README of the [original dataset](https://github.com/zygmuntz/goodbooks-10k)

- The [article linked on the dataset](http://fastml.com/goodbooks-10k-a-new-dataset-for-book-recommendations/)

- The [Kaggle which has descriptions for the previous, unupdated version of the github dataset I'm using](https://www.kaggle.com/datasets/zygmunt/goodbooks-10k#books.csv).


