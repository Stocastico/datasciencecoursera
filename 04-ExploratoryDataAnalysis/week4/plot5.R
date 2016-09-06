## download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip", method = "libcurl")
unzip("data.zip")

## read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## subset the data
baltimore <- NEI[which(NEI$fips == 24510), ]
temp <- grepl("Vehicle", SCC$Short.Name)
vehicleSCC <- SCC[temp, 1]
vehicleBaltimore <- baltimore[as.factor(baltimore$SCC) %in% vehicleSCC, ]

##compute the sum of emission per year
sumsVehicleBaltimore <- aggregate(Emissions ~ year, data = vehicleBaltimore, FUN = sum)

## plot on png
png("plot5.png")
with(sumsVehicleBaltimore, print(qplot(year, Emissions, main = "Vehicle related emissions\nin Baltimore", xlab = "Year", ylab = "Emissions")))
dev.off()
