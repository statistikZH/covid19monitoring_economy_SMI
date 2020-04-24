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
pp<-data.frame(tidyquant::tq_get(c("^SSMI", "CHFEUR=X", "CHFUSD=X", "CL=F"), get = "stock.prices"))

################################

# Format data according to data structure specification
smi_index<-with(subset(pp, symbol=="^SSMI"), data.frame(
                date=as.POSIXct(paste(date, "00:00:00", sep=" ")), 
                value=round(close, 2), 
                topic="Wirtschaft", 
                variable_short="smi_index",
                variable_long="Indexwert SMI",
                location="CH",
                unit="Index-Punkte", 
                source="yahoo finance",
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
                source="yahoo finance",
                update="täglich",
                public="ja",
                description="https://github.com/statistikZH/covid19monitoring_economy_SMI"))


smi_volume<-subset(smi_volume, value!=0)

chf_eur<-with(subset(pp, symbol=="CHFEUR=X"), data.frame(
  date=as.POSIXct(paste(date, "00:00:00", sep=" ")), 
  value=round(close, 3),
  topic="Wirtschaft", 
  variable_short="chf_eur",
  variable_long="Wechselkurs Fr./Euro",
  location="CH",
  unit="CHF/EUR",
  source="yahoo finance",
  update="täglich",
  public="ja",
  description="https://github.com/statistikZH/covid19monitoring_economy_SMI"))

chf_usd<-with(subset(pp, symbol=="CHFUSD=X"), data.frame(
  date=as.POSIXct(paste(date, "00:00:00", sep=" ")), 
  value=round(close,3),
  topic="Wirtschaft", 
  variable_short="chf_usd",
  variable_long="Wechselkurs Fr./US-Dollar",
  location="CH",
  unit="CHF/USD",
  source="yahoo finance",
  update="täglich",
  public="ja",
  description="https://github.com/statistikZH/covid19monitoring_economy_SMI"))


oil<-with(subset(pp, symbol=="CL=F"), data.frame(
  date=as.POSIXct(paste(date, "00:00:00", sep=" ")), 
  value=round(close,3),
  topic="Wirtschaft", 
  variable_short="oil_fut_ny",
  variable_long="Ölpreis",
  location="NY, US",
  unit="USD",
  source="yahoo finance",
  update="täglich",
  public="ja",
  description="https://github.com/statistikZH/covid19monitoring_economy_SMI"))



all<-rbind(smi_index, chf_eur, chf_usd, smi_volume, oil)
all<-subset(all, date > "2019-12-31", is.na(value)==F)


################################
#uppercase
# export result
write.table(all, "Economy_SMI.csv", sep=",", fileEncoding="UTF-8", row.names = F)

range(all$date)

