## download
download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 'dataset.zip')

## unzip
unzip ("dataset.zip", exdir = ".")

## import
data <- read.table('household_power_consumption.txt', header = TRUE, sep = ";", na.strings = "?", stringsAsFactors = F)

## convert dates and times
data$DateTime <- paste(data$Date, data$Time, sep = " ")
data$DateTime <- strptime(data$DateTime, "%d/%m/%Y %H:%M:%S")

## remove Date and Time columns
data$Date <- NULL
data$Time <- NULL

## subset
start <- as.POSIXct("01/02/2007 00:00:00", "%d/%m/%Y %H:%M:%S", tz = "")
end <- as.POSIXct("02/02/2007 23:59:00", "%d/%m/%Y %H:%M:%S", tz = "")
data <- subset(data, data$DateTime >= start & data$DateTime <= end)

## plot the data on png
png('plot4.png')
par(mfrow=c(2,2))
#1st plot
plot(data$DateTime, data$Global_active_power, ylab = "Global Active Power", type = "l", xlab = "")
#2nd plot
plot(data$DateTime, data$Voltage, xlab = "datetime", col = 'black', ylab = 'Voltage', type = "l" )
#3rd plot
plot(data$DateTime, data$Sub_metering_1, ylab = "Energy sub metering", type = "l", xlab = "", col = 'black')
lines(data$DateTime, data$Sub_metering_2, col = 'red')
lines(data$DateTime, data$Sub_metering_3, col = 'blue')
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3" ), col = c('black', 'red', 'blue'), lty = c(1,1,1), bty = 'n')
#4th plot
plot(data$DateTime, data$Global_reactive_power, ylab = "Global_reactive_power", type = "l", xlab = "datetime")

## never forget to call dev.off()
dev.off()
