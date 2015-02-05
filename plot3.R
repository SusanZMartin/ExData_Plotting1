## The code below reads in the data from the original zip file (obtained from
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## on February 3, 2015) once it is unzipped and stored in your working directory
## and processes that data so that it is ready to be used to create the plots in
## this assignment



## read in a subset of the big dataset with a variety of settings

householdpwr <- read.csv2("household_power_consumption.txt", sep=";", quote = "\"", skip = 66636, nrows = 2881, stringsAsFactors = FALSE )


## rename the column heads

names(householdpwr) <- c("OldDate", "OldTime", "GlobalActivePower","GlobalReactivePower", "Voltage", "GlobalIntensity", "SubMetering1", "SubMetering2", "SubMetering3")

## add a zero to month numbers so that 30/1/2007 becomes 30/01/2007 - create a new column
## and cbind it to the existing data frame - also need to add a 0 to day - this doesn't seem
## to be working - check it out tomorrow (February 3, 2015)

testHHpwr <- gsub("/2/","/02/", householdpwr[,1])
testHHpwr <- gsub("2/02","02/02", testHHpwr)
testHHpwr <- gsub("3/02","03/02", testHHpwr)
testHHpwr <- gsub("4/02","04/02", testHHpwr)
newdates <- as.Date(testHHpwr, "%d/%m/%Y")

## fix times as per intstructions - not quite sure yet why I need to fix times

newtimes <- householdpwr[,2]

x <- paste(newdates, newtimes)

newdateandtime <- as.POSIXct(x)





## cbind the combined date and time to householdpwr and then add a weekday variable


newHHpwr <- cbind(newdateandtime, householdpwr)

newHHpwr <- mutate(newHHpwr, weekday = wday(newdateandtime, label=TRUE))

## create plot3 - empty at first then add the coloured lines

png(file = "plot3.png", width = 480, height = 480)

plot(newHHpwr$newdateandtime, as.numeric(newHHpwr$SubMetering1), type = "n", xlab = "", ylab = "Energy sub metering")

lines(newHHpwr$newdateandtime, newHHpwr$SubMetering1, col = "black")
lines(newHHpwr$newdateandtime, newHHpwr$SubMetering2, col = "red")
lines(newHHpwr$newdateandtime, newHHpwr$SubMetering3, col = "blue")

## add the legend

legend("topright", c("Sub_metering_1 ", "Sub_metering_2 ", "Sub_metering_3 "), col = c("black", "red", "blue"),
text.col = "black", lty = c(1, 1, 1), pch = c(NA, NA, NA),
merge = TRUE, cex = 0.8 )


## copy to file as 480 x 480 pixels



dev.off()