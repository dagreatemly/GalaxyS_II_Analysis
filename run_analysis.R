library(dplyr)
library(tidyr)


activity_labels <- read.table(file("./UCI HAR Dataset/activity_labels.txt"))
activity <- as.vector(activity_labels[,2])
map <- function(i) {
     i <- activity[i]
}

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
s <- tbl_df(data.frame(s))
y <- select(s, mean_ = contains("mean"))
z <- select(s, std_ = contains("std"))
x <- select(s, 1:2)
s <- cbind(x, y, z)
sgat <- gather(s, stat_feature, value, -subject, -activity)
ssep <- separate(sgat, stat_feature, c("stat", "feature"))

mat <- tbl_df(data.frame(matrix(1:561, nrow=1, ncol=561)))
colnames(mat) <- features
mat <- select(mat, contains("mean()"))
f <- colnames(mat)
f <- lapply(strsplit(f, "-mean()"), function(x) {
  paste(x[[1]],x[[2]])
  })

map2 <- function(i) {
     i <- f[[i]]
}
ssep$feature <- lapply(as.numeric(ssep$feature), map2)
ssep <- tbl_df(ssep)
ssep$feature <- as.character(ssep$feature)
write.table(ssep, file = "~/GitHub/GalaxyS_II_Analysis/tidy_output.txt", row.names=FALSE)
