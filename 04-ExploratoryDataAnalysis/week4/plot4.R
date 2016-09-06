## download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip", method = "libcurl")
unzip("data.zip")

## read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##extract sources related to coal combustion
temp <- grepl("Coal", SCC$Short.Name)
coalCombSCC <- SCC[temp, 1]
coalNEI <- NEI[as.factor(NEI$SCC) %in% coalCombSCC, ]

## compute the total sums of emission per year
sumsCoal <- aggregate(Emissions ~ year, data = coalNEI, FUN = sum)

## plot on png
png("plot4.png")
print(qplot(sumsCoal$year, sumsCoal$Emissions, main = "Coal related emissions", xlab = "Year", ylab = "Emissions"))
dev.off()