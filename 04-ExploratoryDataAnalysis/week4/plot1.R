## download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip", method = "libcurl")
unzip("data.zip")

## read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## compute the total sums of emission per year
sums <- aggregate(Emissions ~ year, data = NEI, FUN = sum)

## plot on png
png("plot1.png")
plot(sums$year, sums$Emissions, xlab = "Year", ylab = "Emissions")
title("Total emissions per year")
abline(lm(Emissions ~ year,sums))
dev.off()