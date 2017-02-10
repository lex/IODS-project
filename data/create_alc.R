# Atte Keltanen
# Wed Feb  8 12:34:49 EET 2017
# Data wrangling exercise to join data together from different sources

library(dplyr)

# read the math class questionaire data into memory
math_class <- read.table("student-mat.csv", sep = ";", header = TRUE)

# read the portuguese class questionaire data into memory
portuguese_class <- read.table("student-por.csv", sep = ";", header = TRUE)

str(math_class)
dim(math_class)

str(portuguese_class)
dim(portuguese_class)

join_by_columns <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery", "internet")

# join the two datasets by the selected identifiers
math_portuguese <- inner_join(math_class, portuguese_class, by = join_by_columns, suffix = c(".math", ".por"))

str(math_portuguese)
dim(math_portuguese)

alc <- select(math_portuguese, one_of(join_by_columns))

notjoined_columns <- colnames(math_class)[!colnames(math_class) %in% join_by_columns]

for (column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_portuguese, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]

  # if that first column vector is numeric...
  if (is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)

write.csv(alc, file="alcohol_use.csv", row.names=FALSE)
