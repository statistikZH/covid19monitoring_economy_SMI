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
pp<-data.frame(tidyquant::tq_get(c("^SSMI", "CHFEUR=X", "CHFUSD=X"), get = "stock.prices"))

################################

# Format data according to data structure specification
smi_index<-with(subset(pp, symbol=="^SSMI"), data.frame(
                date=as.POSIXct(paste(date, "00:00:00", sep=" ")), 
                value=close, 
                topic="Wirtschaft", 
                variable_short="smi_index",
                variable_long="Indexwert SMI",
                location="CH",
                unit="Index-Punkte", 
                origin="yahoo finance",
                update="täglich",
                public="ja",
                description="https://github.com/statistikZH/covid19monitoring_economy_SMI"))

smi_volume<-with(subset(pp, symbol=="^SSMI"), data.frame(
                date=as.POSIXct(paste(date, "00:00:00", sep=" ")), 
                value=volume/10^6,
                topic="Wirtschaft", 
                variable_short="smi_volumen",
                variable_long="Handelsvolumen SMI",
                location="CH",
                unit="Anzahl Transaktionen in Mio.",
                origin="yahoo finance",
                update="täglich",
                public="ja",
                description="https://github.com/statistikZH/covid19monitoring_economy_SMI"))


chf_eur<-with(subset(pp, symbol=="CHFEUR=X"), data.frame(
  date=as.POSIXct(paste(date, "00:00:00", sep=" ")), 
  value=close,
  topic="Wirtschaft", 
  variable_short="chf_eur",
  variable_long="Wechselkurs Fr./Euro",
  location="CH",
  unit=NA,
  origin="yahoo finance",
  update="täglich",
  public="ja",
  description="https://github.com/statistikZH/covid19monitoring_economy_SMI"))

chf_usd<-with(subset(pp, symbol=="CHFUSD=X"), data.frame(
  date=as.POSIXct(paste(date, "00:00:00", sep=" ")), 
  value=close,
  topic="Wirtschaft", 
  variable_short="chf_usd",
  variable_long="Wechselkurs Fr./US-Dollar",
  location="CH",
  unit=NA,
  origin="yahoo finance",
  update="daily",
  public="ja",
  description="https://github.com/statistikZH/covid19monitoring_economy_SMI"))

all<-rbind(smi_volume, smi_index, chf_eur, chf_usd)
all<-subset(all, date > "2019-01-01")






################################

# export result
write.table(all, "economy_SMI.csv", sep=",", fileEncoding="UTF-8", row.names = F)


