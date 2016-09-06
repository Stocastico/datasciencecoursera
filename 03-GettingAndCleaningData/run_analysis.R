library(plyr)
## This script reads data from files, add meaningful names
## and merges all the information in one single column.
## After that, averages of all the features are computed
## for each subject and each activity labels. More information
## about the script and the dataset used are available in
## the Codebook.
## To run the script, simply call source('runAnalysis.R)


## download and unzip the data (uncomment if required)
initialdir <- getwd()
##download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "uciData.zip")
##unzip("uciData.zip")

## read data from training and test files
setwd("UCI HAR Dataset/train")
subjecttrain <- read.table("subject_train.txt")
featurestrain <- read.table("X_train.txt")
activitytrain <- read.table("y_train.txt")
trainall <- cbind(featurestrain, subjecttrain, activitytrain)
setwd("../test")
subjecttest <- read.table("subject_test.txt")
featurestest <- read.table("X_test.txt")
activitytest <- read.table("y_test.txt")
testall <- cbind(featurestest, subjecttest, activitytest)

## merge the two datasets, keep only desired columns
dataall <- rbind(trainall, testall)
data <- dataall[, c(1:6, 41:46, 81:86, 121:126, 161:166,
                    201:202, 214:215, 227:228, 240:241,
                    253:254, 266:271, 345:350, 424:429,
                    503:504, 516:517, 529:530, 542:543,
                    ncol(dataall)-1, ncol(dataall))] #subject and activity

## clean the workspace by removal of unnecessary data
rm(dataall, featurestest, featurestrain, subjecttest,
   subjecttrain, testall, trainall, activitytest, activitytrain)

## get feature names
setwd(initialdir)
featurenames <- read.table('UCI HAR Dataset/features.txt')
featurenames <- grep("mean\\(|std\\(", featurenames[, 2], value = TRUE)
activitylabels <- read.table('UCI HAR Dataset/activity_labels.txt')

## set feature names, subject ID and activity
data[, ncol(data)] <- factor(data[, ncol(data)])
colnames(data) <- c(featurenames, "Subject", "Activity")
levels(data$Activity) <- activitylabels[, 2]

## now our data is clean. Compute averages of each variable for
## every subject and for every activity
tidydata <- aggregate(. ~ Subject + Activity, data = data, FUN = mean )
tidydata <- tidydata[order(tidydata$Subject), ]
