
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "household_power_consumption.zip")
# uncompresses the archives in the working directory
unzip("household_power_consumption.zip")


data <- read.table("household_power_consumption.txt", header = TRUE, sep=";", stringsAsFactors=FALSE)
Sys.setlocale(locale = "USA")
library(dplyr)
library(lubridate)
data<-tbl_df(data)
str(data)
# convert char to num
data <- data %>% dplyr::mutate(Sub_metering_1=as.numeric(Sub_metering_1))
data <- data %>% dplyr::mutate(Sub_metering_2=as.numeric(Sub_metering_2))
data <- data %>% dplyr::mutate(Global_active_power=as.numeric(Global_active_power))
data <- data %>% dplyr::mutate(Global_reactive_power=as.numeric(Global_reactive_power))
data <- data %>% dplyr::mutate(Voltage=as.numeric(Voltage))
# antes de convertir a date, hay que unir Date con Time
data$datetime <- paste(data$Date, data$Time)               # me gustaría saber cómo escribir esto sin $
#convert char to date
data$datetime2 <- dmy_hms(data$datetime)


data <- data %>% dplyr::mutate(datetime=strptime(datetime, format="%d/%m/%Y %H:%M:%S") )
left_date <- as.Date("2007/02/01")
data <- data %>% filter(datetime>left_date)
right_date <- as.Date("2007/02/03")
data <- data %>% filter(datetime<right_date)


# plot 4
png("plot4.png", height = 480 , width = 480)
par(mfrow = c(2, 2))
plot(Global_active_power ~ datetime2, data = data, type="l", xlab="", ylab="Global Active Power (kilowatts)")# 
plot(Voltage ~ datetime2, data = data, type="l", xlab="datetime", ylab="Global Active Power (kilowatts)")# 
plot(Sub_metering_1 ~ datetime2, data = data, type="l", xlab="", ylab="Energy Sub Metering")#
lines(Sub_metering_2 ~ datetime2, data = data, type="l", col="red")
lines(Sub_metering_3 ~ datetime2, data = data, type="l", col="blue")
legend("topright",pch ="___", col = c("black", "red", "blue"),legend= c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       
)
plot(Global_reactive_power ~ datetime2, data = data, type="l", xlab="datetime", ylab="Global Reactive Power (kilowatts)")# 
dev.off()