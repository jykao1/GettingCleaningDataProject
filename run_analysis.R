## 1. Merges the training and the test sets to create one data set.
## 2. Extractsx only the measurements on the mean and the standard deviation
##    for each measurement.
## 3. Uses desscriptive activity names to name the activities in the data set.
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data
##    set with the average of each variable for each activity and each subject.

## Using packages: data.table and dplyr
library(data.table)
library(dplyr)

## Rading data column labels from txt file
featureName <- read.table("features.txt", header=FALSE)

## Reading test and train data set into table
xTest <- read.table("./test/X_test.txt", header=FALSE)
xTrain <- read.table("./train/X_train.txt", header=FALSE)

## Reading test and train labels into table
yTest <- read.table("./test/Y_test.txt", header=FALSE)
yTrain <- read.table("./train/Y_train.txt", header=FALSE)

## Reading test and train subject into table
subTrain <- read.table("./train/subject_train.txt", header=FALSE)
subTest <- read.table("./test/subject_test.txt", header=FALSE)

## Merging data sets
subject <- rbind(subTest, subTrain)
feature <- rbind(xTrain, xTest)
activity <- rbind(yTrain, yTest)

## Put column names in feature table
names(feature) <- featureName$V2
names(subject) <- "subject"
names(activity) <- "activity"

## 1. Combine all data into one data set
alldata <- cbind(feature, activity, subject)

## 2. Extracts only mean and standard deviation(Std) in the measurement/columns
cMeanStd <- grep("(.*)Mean(.*)|(.*)Std(.*)",names(alldata), ignore.case=TRUE)
exractCol <- c(cMeanStd, 562:563)
extractData <- alldata[,extractCol]

## 3. Uses descriptive names to name the activities in the data set
activityLabels <- read.table("activity_labels.txt", header=FALSE)
extractData$activity <- activityLabels[extractData$activity,2]

## 4. Appropriately labels the data set
names(extractData) <- gsub("-","",names(extractData))
names(extractData) <- gsub("\\(","",names(extractData))
names(extractData) <- gsub("\\)","",names(extractData))
names(extractData) <- gsub(",","",names(extractData))

## 5. Creates independent tidy data set with average of each varaiable
##    for each activity and each subject.
groupData <- group_by(extractData, activity, subject)
finalData <- summarize_each(groupData,mean)
