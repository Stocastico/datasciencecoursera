if ( !file.exists('StormData.csv.bz2') ) {
  download.file('https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2',
                'StormData.csv.bz2'  )
}
storm <- read.csv( 'StormData.csv.bz2' )

str(storm)
deainj <- aggregate(cbind(INJURIES, FATALITIES) ~ EVTYPE, storm, FUN = sum, na.rm = TRUE)
deainj$INJURIES_AND_DEATHS <- deainj$INJURIES + deainj$FATALITIES
max_deaths <- max(deainj$FATALITIES)
max_injuries <- max(deainj$INJURIES)
max_combined <- max(deainj$INJURIES_AND_DEATHS)
event_max_deaths <- as.character(deainj[[which.max(deainj$FATALITIES), 'EVTYPE']])
event_max_injuries <- as.character(deainj[[which.max(deainj$INJURIES), 'EVTYPE']])

storm$PROPDMGEXP_CLEAN <- 0
storm$PROPDMGEXP_CLEAN[grep("k", storm$PROPDMGEXP,ignore.case = T)] <- 3
storm$PROPDMGEXP_CLEAN[grep("m", storm$PROPDMGEXP,ignore.case = T)] <- 6
storm$PROPDMGEXP_CLEAN[grep("b", storm$PROPDMGEXP,ignore.case = T)] <- 9
storm$PROPDMG_TOT <- 10^as.numeric(storm$PROPDMGEXP_CLEAN) * storm$PROPDMG

storm$CROPDMGEXP_CLEAN <- 0
storm$CROPDMGEXP_CLEAN[grep("k", storm$CROPDMGEXP,ignore.case = T)] <- 3
storm$CROPDMGEXP_CLEAN[grep("m", storm$CROPDMGEXP,ignore.case = T)] <- 6
storm$CROPDMGEXP_CLEAN[grep("b", storm$CROPDMGEXP,ignore.case = T)] <- 9
storm$CROPDMG_TOT <- 10^as.numeric(storm$CROPDMGEXP_CLEAN) * storm$CROPDMG

damage <- aggregate(cbind(CROPDMG_TOT, PROPDMG_TOT) ~ EVTYPE, storm, FUN = sum, na.rm = TRUE)
damage$CROP_AND_PROP <- damage$CROPDMG_TOT + damage$PROPDMG_TOT
head(damage)

max_crop_dmg <- max(damage$CROPDMG_TOT)
max_prop_dmg <- max(damage$PROPDMG_TOT)
max_damage <- max(damage$CROP_AND_PROP)
event_max_crop_dmg <- as.character(damage[[which.max(damage$CROPDMG_TOT), 'EVTYPE']])
event_max_prop_dmg <- as.character(deainj[[which.max(damage$PROPDMG_TOT), 'EVTYPE']])

sorted_deainj <- deainj[order(deainj$INJURIES_AND_DEATHS, decreasing = TRUE), ]
sorted_damage <- damage[order(damage$CROP_AND_PROP, decreasing = TRUE), ]
plot_deainj <- matrix(c(head(sorted_deainj$INJURIES), head(sorted_deainj$FATALITIES)),
                      nrow=2, byrow=T)
plot_damage <- matrix(c(head(sorted_damage$CROPDMG_TOT), head(sorted_damage$PROPDMG_TOT/10)),
                      nrow=2, byrow=T)

barplot( plot_deainj, beside = TRUE, col=c("coral1","cornflowerblue"),
         cex.names = 0.8, las = 2, legend=c("Injuries","Fatalities"),
         names.arg = head(sorted_deainj$EVTYPE),
         main = "Injuries and fatalities\nof the most dangerous weather events")

barplot( plot_damage, beside = TRUE, col=c("darkorange","darkslateblue"),
         cex.names = 0.8, las = 2, legend=c("Crop damage (B$)","Property damage (10B$)"),
         names.arg = head(sorted_damage$EVTYPE),
         main = "Damage to crop and properties\nfor weather events doing the most damage")
