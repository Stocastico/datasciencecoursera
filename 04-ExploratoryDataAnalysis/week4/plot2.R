## download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip", method = "libcurl")
unzip("data.zip")

## read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## compute the total sums of emission per year
baltimore <- NEI[which(NEI$fips == 24510), ]
sumsBaltimore <- aggregate(Emissions ~ year, data = baltimore, FUN = sum)

## plot on png
png("plot2.png")
plot(sumsBaltimore$year, sumsBaltimore$Emissions, xlab = "Year", ylab = "Emissions")
title("Emissions in Baltimore per year")
abline(lm(Emissions ~ year,sumsBaltimore))
dev.off()