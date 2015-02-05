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

## add a zero to month numbers so that 30/1/2007 becomes 30/01/2007 and then
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


## creates plot2.png

png(file = "plot2.png", width = 480, height = 480)

plot(newHHpwr$newdateandtime, as.numeric(newHHpwr$GlobalActivePower), type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

dev.off()
