---
title: "Clean Data"
author: "Stefano Masneri"
date: "10. Februar 2016"
output: 
  html_document: 
    theme: readable
---

# Project description

This is an R Markdown document which describes the steps used to complete the homework assignment in the course "Getting and Cleaning Data".

# Description of the original dataset

The original dataset represents data collected from the accelerometer of a smartphone. This is the description of the features available, as described in the dataset page:

> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.
> Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.
> Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).
> Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).
> These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

Summing it up, this is the list of signals extracted (XYZ represent the axial direction of the signal):

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

Several variables were estimated from each signals, but for this project we only focused on *mean* and *standard deviation*.
Apart from these variables the original dataset contains information about the 30 subjects who conducted the experiment and the activity that they were performing while the data was recorded. The *Subjects* are represented by a single number between 1 and 30 while the *Activity* was represented with a number between 1 and 6, using this convention:

* 1 = WALKING
* 2 = WALKING_UPSTAIRS
* 3 = WALKING_DOWNSTAIRS
* 4 = SITTING
* 5 = STANDING
* 6 = LAYING

# Data acquisition

The script assumes that the dataset has already been downloaded and extracted in a folder called *UCI HAR DATASET*, stored in the same directory of the script. Lines 13-14 of the script show the code used to download and unzip the data and they can be uncommented if the original data is not available.

# Data cleaning

The first step for cleaning the data was to collect information about the varibales, the subjects and the activity both for the training data and for the test data. This lead to a total of 10299 observation. Since we were interested in just the mean and the standard deviation of each variable, we discarded all the undesired variables and this resulted in a table with 68 columns, of which 66 represented the variables, one for the subjects and one for the activity. This data was then stored as **data**.

The next step was then to assign meaningful names to each column in the data table. For consistency reasons, all the variable names are the same as in the dataset description. The final two columns were simply named *Subject* and *Activity*. Furthermore, all the values of activity were replaced with the actual activity performed for ease of understanding.

# Data summarization

Finally, the **data** was summarized in a new table called **tidydata**. This new table contains the average of each variable for each activity and each subject, ordered according to the subject ID in ascending order.
