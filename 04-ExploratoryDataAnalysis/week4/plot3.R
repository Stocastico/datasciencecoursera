## download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip", method = "libcurl")
unzip("data.zip")

## read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## compute the total sums of emission per year
baltimore <- NEI[which(NEI$fips == 24510), ]
sumsBaltimore <- aggregate(Emissions ~ year+type, data = baltimore, FUN = sum)

## plot on png
png("plot3.png")
plot3 <- with(sumsBaltimore, qplot(year, Emissions, color = type, xlab = "Year", ylab = "Emissions"))
plot3 <- plot3 + ggtitle("Emissions in Baltimore per year\n separate types")
plot3 <- plot3 + guides(fill=guide_legend(title="Type"))
print(plot3)
dev.off()