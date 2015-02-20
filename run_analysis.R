library(dplyr)
library(tidyr)

map <- function(i) {
     i <- activity[i]
}

activity_labels <- read.table(file("./UCI HAR Dataset/activity_labels.txt"))
activity <- as.vector(activity_labels[,2])


features <- read.table(file("./UCI HAR Dataset/features.txt"), stringsAsFactors = FALSE)[,2]
trainingSet <- read.table(file("./UCI HAR Dataset/train/X_train.txt"), stringsAsFactors = FALSE)
trainingSet <- tbl_df(trainingSet)
d <- duplicated(features)
index <- 1:561
bad <- index[d]
features[bad] <- bad
names(trainingSet) <- features
trainingSet <- select(trainingSet, contains("mean()"), contains("std()"))


subjects <- read.table(file("./UCI HAR Dataset/train/subject_train.txt"))
activityNum <- read.table(file("./UCI HAR Dataset/train/y_train.txt"))
labels <- cbind(subjects, activityNum)
names(labels) <- c("subject", "activity")
trainingSet <- cbind(labels, trainingSet)

actTest <- read.table(file("UCI HAR Dataset/test/y_test.txt"))
actTest <- as.vector(actTest[[1]])
actTest <- sapply(actTest, map)

testSet <- read.table(file("./UCI HAR Dataset/test/X_test.txt"), stringsAsFactors = FALSE)
testSet <- tbl_df(testSet)
names(testSet) <- features
testSet <- select(testSet, contains("mean()"), contains("std()"))

testSubjects <- read.table(file("./UCI HAR Dataset/test/subject_test.txt"))
testActivityNum <- read.table(file("./UCI HAR Dataset/test/y_test.txt"))
testLabels <- cbind(testSubjects, testActivityNum)
names(testLabels) <- c("subject", "activity")
testSet <- cbind(testLabels, testSet)

data <- rbind(trainingSet, testSet)
f1 <- data$subject
f2 <- data$activity
s <- lapply(split(data, list(f1, f2)), function(x) {
     x <- colMeans(x)})
s <- data.frame(s)
s <- t(s)

s[,"activity"] <- sapply(s[,"activity"], map)
rownames(s) <- NULL

write.table("./tidy.txt", row.name=FALSE)