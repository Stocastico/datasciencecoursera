# Reproducible Research: Peer Assessment 1
Stefano Masneri  
2016-03-02  

## Before we start
We load all the library we need for the analysis

```r
library(ggplot2)
```

Then set some global options for knitr

```r
knitr::opts_chunk$set(fig.width=12, fig.height=8, fig.path='figures/', fig.keep='high' )
```

## Loading and preprocessing the data
To avoid repeating unnecessary operation, we perform a basic check:
if the data does not exist in pur folder, we extract it from the
zip file provided for the assignment.

```r
if ( !file.exists("activity.csv") ) {
  unzip('activity.zip')
}
activity <- read.csv("activity.csv")
```

We then proceed to make the data tidy, by converting dates into date objects.

```r
activity$date <- as.Date(activity$date, "%Y-%m-%d") 
```

## What is mean total number of steps taken per day?
At first we just compute the total steps per day, ignoring any NAs, and then plot the histogram
We then proceed to compute the mean and median value, and display it on the plot

```r
sumSteps <- tapply(activity$steps, activity$date, FUN = sum, na.rm = TRUE)
meanSteps <- mean(sumSteps, na.rm = TRUE)
meanSteps
```

```
## [1] 9354.23
```

```r
medianSteps <- median(sumSteps, na.rm = TRUE)
medianSteps
```

```
## [1] 10395
```

```r
hist( sumSteps, breaks = 50, main = "Histogram of steps per day", xlab = "# steps" )
abline( v = meanSteps, col='lightgray', lty = 2, lwd = 2)
abline( v = medianSteps, col='brown3', lty = 3, lwd = 2)
legend("topright", c("Mean", "Median"), lty = c(2, 3), lwd = c(2, 2), col = c('lightgray', 'brown'))
```

![](figures/total_steps_per_day-1.png)

## What is the average daily activity pattern?
We have to compute the number of steps per time interval
And then we extract the maximum value and its position

```r
sumStepsPerInterval <- aggregate(steps ~ interval, activity, FUN = sum, na.rm = TRUE)
plot(sumStepsPerInterval$interval, sumStepsPerInterval$steps, type = 'l', xlab = 'time interval', ylab = '# steps')
maxNumSteps <- max(sumStepsPerInterval$steps)
timeMaxSteps <- sumStepsPerInterval$interval[which.max(sumStepsPerInterval$steps)]
points(timeMaxSteps, maxNumSteps, col = 'red', pch = 18)
```

![](figures/steps_per_time_interval-1.png)

## Imputing missing values
The first thing to do is to compute the total number of rows containing NA values
Then we will create a new dataframe, equal to activity, but we will replace the NAs
With valid values (in our case, the mean of the day)

```r
medianStepsPerInterval <- aggregate(steps ~ interval, activity, FUN = median, na.rm = TRUE)
NArows <- sum(is.na(activity))
NArows
```

```
## [1] 2304
```

```r
activityNoNAs <- activity
activityNoNAs$wasNA <- is.na(activity$steps)
medianArray <- rep(medianStepsPerInterval$steps,length(unique(activity$date)))
activityNoNAs[activityNoNAs$wasNA, ]$steps <- medianArray[activityNoNAs$wasNA]
```

## Are there differences in activity patterns between weekdays and weekends?
First, let's define a new column, day, containing either weekday or weekend

```r
activityNoNAs$day <- "weekday"
activityNoNAs$day[weekdays(activityNoNAs$date) == "Sunday" | weekdays(activityNoNAs$date) == "Saturday" ] = "weekend"
activityNoNAs$day <- as.factor(activityNoNAs$day)
```

Then we can create a plot which highlights (if any) the different pattern according 
to whether it is weekend or not

```r
stepsByDayAndInt <- aggregate(steps ~ interval+day, activityNoNAs, FUN = mean, na.rm = TRUE)
ggplot(stepsByDayAndInt, aes(x = interval, y = steps, color = day))  + facet_grid(. ~ day) + geom_line()
```

![](figures/plot_per_weekday-1.png)

