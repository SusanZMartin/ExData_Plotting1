## note that code used to create plot starts on line 50 if you want to skip to there

## The code below reads in the data from the original zip file (obtained from
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
## on February 3, 2015) once it is unzipped and stored in your working directory
## and processes that data so that it is ready to be used to create the plots in
## this assignment



## read in a subset of the big dataset with a variety of settings
## included row 2881 (third day of February) because I thought it might be needed
## to make plots display Saturday

householdpwr <- read.csv2("household_power_consumption.txt", sep=";", quote = "\"", skip = 66636, nrows = 2881, stringsAsFactors = FALSE )


## rename the column heads

names(householdpwr) <- c("OldDate", "OldTime", "GlobalActivePower","GlobalReactivePower", "Voltage", "GlobalIntensity", "SubMetering1", "SubMetering2", "SubMetering3")

## add a zero to month and day numbers so that 2/2/2007 becomes 02/02/2007 and then
## convert to proper format using as.Date

testHHpwr <- gsub("/2/","/02/", householdpwr[,1])
testHHpwr <- gsub("2/02","02/02", testHHpwr)
testHHpwr <- gsub("3/02","03/02", testHHpwr)
testHHpwr <- gsub("4/02","04/02", testHHpwr)
newdates <- as.Date(testHHpwr, "%d/%m/%Y")

## create another vector with the times

newtimes <- householdpwr[,2]

## paste times and dates together to create a properly formatted variable and then cbind
## with rest of dataset

x <- paste(newdates, newtimes)

newdateandtime <- as.POSIXct(x)

newHHpwr <- cbind(newdateandtime, householdpwr)

## Added in a weekday field because I thought it might be needed for the plots
## it wasn't but I just left it

newHHpwr <- mutate(newHHpwr, weekday = wday(newdateandtime, label=TRUE))


## create plot4 - create the empty plotting area with two rows and two columns

png(file = "plot4.png", width = 480, height = 480)

par(mfcol = c(2,2))

## put in plot 1 for the plotting area (which is plot 2 created earlier with slight change to
## y axis text - remove kilowatts)

plot(newHHpwr$newdateandtime, as.numeric(newHHpwr$GlobalActivePower), type = "l", xlab = "", ylab = "Global Active Power")

## put in plot 2 for the plotting area (which is plot 3 created earlier)


plot(newHHpwr$newdateandtime, as.numeric(newHHpwr$SubMetering1), type = "n", xlab = "", ylab = "Energy sub metering")

lines(newHHpwr$newdateandtime, newHHpwr$SubMetering1, col = "black")
lines(newHHpwr$newdateandtime, newHHpwr$SubMetering2, col = "red")
lines(newHHpwr$newdateandtime, newHHpwr$SubMetering3, col = "blue")

## add the legend

legend("topright", c("Sub_metering_1 ", "Sub_metering_2 ", "Sub_metering_3 "), col = c("black", "red", "blue"),
text.col = "black", lty = c(1, 1, 1), pch = c(NA, NA, NA),
merge = TRUE, cex = 0.8 )

## put in plot 3 for the plotting area (which is a new plot)

plot(newHHpwr$newdateandtime, as.numeric(newHHpwr$Voltage), type = "l", xlab = "datetime", ylab = "Voltage")

## put in plot 4 for the plotting area (which is a new plot)

plot(newHHpwr$newdateandtime, as.numeric(newHHpwr$GlobalReactivePower), type = "l", xlab = "datetime", ylab = "Global_reactive_power")


## don't forget to turn off the graphics device

dev.off()
