# Atte Keltanen
# Sun Jan 29 14:32:20 EET 2017
# Data wrangling exercise to preprocess data for further analysis

library(dplyr)

data_url <- "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt"
lrn14 <- read.table(data_url, sep="\t", header=TRUE)

str(lrn14)
dim(lrn14)

# looks like it's 60 rows with 183 columns.

# Create an analysis dataset with the variables gender, age, attitude, deep,
# stra, surf and points by combining questions in the learning2014 data, as
# defined in the datacamp exercises and also on the bottom part of the following
# page (only the top part of the page is in Finnish).
# http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS2-meta.txt.
# Exclude observations where the exam points variable is zero.
# (The data should then have 166 observations and 7 variables) (1 point)

# scale attitude to its original range
number_of_questions_in_attitude <- 10
lrn14$attitude <- lrn14$Attitude / number_of_questions_in_attitude

# group questions to types

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",
                    "D15", "D23", "D31")
strategic_questions <- c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20",
                         "ST28")
surface_questions <- c("SU02", "SU10", "SU18", "SU26", "SU05", "SU13", "SU21",
                       "SU29", "SU08", "SU16", "SU24", "SU32")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# keep only the columns we need
columns_to_keep <- c("gender", "Age", "attitude", "deep", "stra", "surf", "Points")
learning14 <- select(lrn14, one_of(columns_to_keep))

# rename the capitalized columns
colnames(learning14)[2] <- "age"
colnames(learning14)[7] <- "points"

# filter out the zero point exams
learning14 <- filter(learning14, points > 0)

# confirm that we have 166 observations and 7 variables
str(learning14)

# 4.
# set working directory to the project directory
setwd("../")

# export the csv
write.csv(learning14, file="data/learning2014.csv", row.names=FALSE)

# import the csv again and output some stuff
g <- read.csv("data/learning2014.csv")

str(g)
head(g)

# looks correct to me.
