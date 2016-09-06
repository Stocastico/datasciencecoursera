library(ggplot2)

# get and clean data
if ( !file.exists("activity.csv") ) {
  unzip('activity.zip')
}
activity <- read.csv("activity.csv")
activity$date <- as.Date(activity$date, "%Y-%m-%d")

## compute mean and median
meanSteps <- tapply(activity$steps, activity$date, FUN = mean, na.rm = TRUE)
medianSteps <-  tapply(activity$steps, activity$date, FUN = median, na.rm = TRUE)

## Calculate the total steps per day and plot histogram
sumSteps <- tapply(activity$steps, activity$date, FUN = sum, na.rm = TRUE)
hist(sumSteps, breaks = 25,
      main = "Histogram of steps per day",
      xlab = "# steps" )
## mean and median
meanSteps <- mean(sumSteps, na.rm = TRUE)
medianSteps <- median(sumSteps, na.rm = TRUE)
abline( v = meanSteps, col='lightgray', lty = 2, lwd = 2)
abline( v = medianSteps, col='brown3', lty = 3, lwd = 2)
legend("topright", c("Mean", "Median"), lty = c(2, 3), lwd = c(2, 2), col = c('lightgray', 'brown'))

## steps per time interval, plot as timeseries
sumStepsPerInterval <- aggregate(steps ~ interval, activity, FUN = sum, na.rm = TRUE)
plot(sumStepsPerInterval$interval, sumStepsPerInterval$steps, type = 'l', xlab = 'time interval', ylab = '# steps')
maxNumSteps <- max(sumStepsPerInterval$steps)
timeMaxSteps <- sumStepsPerInterval$interval[which.max(sumStepsPerInterval$steps)]
points(timeMaxSteps, maxNumSteps, col = 'red', pch = 18)

## deal with NAs
medianStepsPerInterval <- aggregate(steps ~ interval, activity, FUN = median, na.rm = TRUE)
NArows <- sum(is.na(activity))
activityNoNAs <- activity
activityNoNAs$wasNA <- is.na(activity$steps)
medianArray <- rep(medianStepsPerInterval$steps,length(unique(activity$date)))
activityNoNAs[activityNoNAs$wasNA, ]$steps <- medianArray[activityNoNAs$wasNA]

## weekdays/weekends
activityNoNAs$day <- "weekday"
activityNoNAs$day[weekdays(activityNoNAs$date) == "Sunday" | weekdays(activityNoNAs$date) == "Saturday" ] = "weekend"
stepsByDayAndInt <- aggregate(steps ~ interval+day, activityNoNAs, FUN = mean)
p <- ggplot(stepsByDayAndInt, aes(x = interval, y = steps, color = day))  + facet_grid(day ~ .) + geom_line()
print(p)