#  Economy_SMI.R

# Import libraries
require(tidyquant)
require(xts)
require(anytime)
library (readr)
library (lattice)
library(chron)
library(reshape)

################################

# Download data
# Download daily closing and volume SMI
pp<-data.frame(tidyquant::tq_get(c("^SSMI"), get = "stock.prices"))

################################

# Format data according to data structure specification
smi_index<-data.frame(
                date=as.POSIXct(paste(pp$date, "00:00:00", sep=" ")), 
                value=pp$close, 
                topic="wirtschaft", 
                variable="smi_index",
                location="CH",
                unit="indexpoints", 
                origin="yahoo finance",
                update="daily",
                public="ja",
                description="daily closing value Swiss Market Index")

smi_volume<-data.frame(
                date=as.POSIXct(paste(pp$date, "00:00:00", sep=" ")), 
                value=pp$volume/10^6,
                topic="wirtschaft", 
                variable="smi_volume",
                location="CH",
                unit="number of transactions in Mio",
                origin="yahoo finance",
                update="daily",
                public="ja",
                description="daily number of traded shares SMI")

smi<-rbind(smi_volume, smi_index)
smi<-subset(smi, date > "2019-01-01")

################################

# export result
write.table(smi, "./Economy_SMI.csv", sep=",", fileEncoding="UTF-8", row.names = F)


