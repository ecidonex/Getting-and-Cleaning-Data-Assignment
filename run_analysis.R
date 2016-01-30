## Getting and Cleaning Data programming assignment

## Load required packages
library(plyr)

##STEP 1: merge training and test data sets for each group 
##read tables
subjecttrain <- read.table("train/subject_train.txt")
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjecttest <- read.table("test/subject_test.txt")
xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")

##merge testing and training datasets and remove unneeded variables
xdata <- rbind(xtrain, xtest)
ydata <- rbind(ytrain, ytest)
subjectdata <- rbind (subjecttrain, subjecttest)
rm(xtrain, ytrain, xtest, ytest, subjecttrain, subjecttest)

##STEP 2 Extract only measurements on mean and standard deviation for each measurement
features <- read.table("features.txt")
mean_std_features <- grep("-(mean|std)\\(\\)", features$V2)
xdata <- xdata[, mean_std_features]

##STEP 3 Use descriptive activity names to name the activities in the dataset
activities <- read.table("activity_labels.txt")
ydata$V1 <- activities[ydata$V1, 2]

## STEP 4 Appropriately label the dataset with descriptive variable names
names(subjectdata) <- "subject"
names(xdata) <- features[mean_std_features, 2]
names(ydata) <- "activities"

#bind x y and subject data into one dataset
combineddata <- cbind(subjectdata, ydata, xdata)

## STEP 5 Create a second tidy data set with the average of each variable for each
## activity and each subject. Write this to a file
tidydata <- ddply(combineddata, c("subject", "activities"), numcolwise(mean))
write.table(tidydata, "means_only.txt", row.names = FALSE)


