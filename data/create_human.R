# Atte Keltanen
# Thu Feb 23 21:55:06 EET 2017
# Data wrangling of HDI data

# Get the datasets
# More information available here:
# http://hdr.undp.org/en/content/human-development-index-hdi
# http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

library(dplyr)

setwd(".")

summary(hd)
dim(hd)
colnames(hd)

summary(gii)
dim(gii)
colnames(gii)

# Tweak the column names to better fit my needs
colnames(hd)[1] <- "hdiRank"
colnames(hd)[2] <- "country"
colnames(hd)[3] <- "hdi"
colnames(hd)[4] <- "lifeExpectancy"
colnames(hd)[5] <- "expectedYearsOfEducation"
colnames(hd)[6] <- "meanYearsOfEducation"
colnames(hd)[7] <- "gni"
colnames(hd)[8] <- "gniMinusHdiRank"

colnames(gii)[1] <- "giiRank"
colnames(gii)[2] <- "country"
colnames(gii)[3] <- "gii"
colnames(gii)[4] <- "maternalMortalityRatio"
colnames(gii)[5] <- "adolescentBirthRate"
colnames(gii)[6] <- "representationInParliament"
colnames(gii)[7] <- "secondaryEducationFemale"
colnames(gii)[8] <- "secondaryEducationMale"
colnames(gii)[9] <- "labourParticipationFemale"
colnames(gii)[10] <- "labourParticipationMale"

# Add education and labour participation ratios
gii <- mutate(gii, femaleToMaleEducationRatio = secondaryEducationFemale / secondaryEducationMale)
gii <- mutate(gii, labourParticipationRatio = labourParticipationFemale / labourParticipationMale)

# Join the datasets together by country
hdi_gii <- inner_join(hd, gii, by = "country", suffix = c(".hd", ".gii"))
colnames(hdi_gii)

# Save it for further use
write.csv(hdi_gii, file="human.csv", row.names=FALSE)

# More wrangling from now on for the new week

# 1. Transform gni to be numeric instead of strings
hdi_gii$gni <- as.numeric(gsub(",", "", hdi_gii$gni))

# 2. Drop unwanted columns
columns_to_keep <- c("country",
                     "femaleToMaleEducationRatio",
                     "labourParticipationRatio",
                     "expectedYearsOfEducation",
                     "lifeExpectancy",
                     "gni",
                     "maternalMortalityRatio",
                     "adolescentBirthRate",
                     "representationInParliament"
                     )

hdi_gii <- select(hdi_gii, one_of(columns_to_keep))

# 3. Remove rows with missing values
hdi_gii <- hdi_gii[complete.cases(hdi_gii),]

# 4. Remove regions
hdi_gii <- head(hdi_gii, -7)

# 5. Change row names to countries and drop the country column
row.names(hdi_gii) <- hdi_gii$country
hdi_gii[1] = NULL

# Save the data again for further use
write.csv(hdi_gii, file="human.csv")
