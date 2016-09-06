## download and unzip data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "data.zip", method = "libcurl")
unzip("data.zip")

## read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## subset the data
balLA <- NEI[which(NEI$fips == "24510" | NEI$fips == "06037"), ]
vehicleSCC <- SCC[grepl("Vehicle", SCC$Short.Name, ignore.case = TRUE), 1]
vehicles <- balLA[as.factor(balLA$SCC) %in% vehicleSCC, ]

##compute the sum of emission per year
sumsVehicles <- aggregate(Emissions ~ year+fips, data = vehicles, FUN = sum)

## plot on png
png("plot6.png")
plot6 <- ggplot(data = sumsVehicles, aes(x = year, y = Emissions, color = fips)) + geom_point()
plot6 <- plot6 + ggtitle("Vehicle related emissions\nin Baltimore and Los Angeles")
plot6 <- plot6 + scale_color_discrete(name="fips", labels = c("Baltimore", "Los Angeles"))
dev.off()
