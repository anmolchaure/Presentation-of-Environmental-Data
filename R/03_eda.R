## data are sourced via 02_data_import script

dta_prec

class(x = dta_prec)
str(object = dta_prec)

## keep cols "START_TIME; VALUE; ID_REGISTRACE; LOKALITA_NAZEV;
##            VELICINA_ZKRATKA; ZEMEPISNA_DELKA; ZEMEPISNA_SIRKA
##            NADMORSKA_VYSKA"
## and convert to cols to correct data classes

unique(x = dta_prec$START_TIME)

dta <- dta_prec[, names(x = dta_prec) %in% c("START_TIME", "VALUE", "ID_REGISTRACE",
                                             "LOKALITA_NAZEV", "VELICINA_ZKRATKA", 
                                             "ZEMEPISNA_DELKA", "ZEMEPISNA_SIRKA",
                                             "NADMORSKA_VYSKA")]

names(x = dta) <- c("date", "value", "reg_id", 
                    "location", "variable",
                    "lon", "lat", 
                    "elevation")

str(object = dta)

a <- dta$date[1]

class(x = a)
nchar(x = a)

as.POSIXct(x = a,
           format = "%Y-%m-%dT%H:%M:%OSZ")

object.size(x = dta)

dta$date <- as.POSIXct(x = dta$date,
                       format = "%Y-%m-%dT%H:%M:%OSZ")

str(object = dta)

dta$location <- as.factor(x = dta$location)
dta$variable <- as.factor(x = dta$variable)
dta$id <- as.factor(x = paste(iconv(x = gsub(pattern = "\\ |\\.|\\/",
                                             replacement = "",
                                             x = dta$location), 
                                    to = "ASCII//TRANSLIT"),
                              dta$reg_id,
                              sep = "_"))

object.size(x = dta)

str(object = dta)

prec <- dta[dta$variable == "rain", c("date", "value", "id")]

unique(x = prec$location)

diff(x = as.Date(x = prec$date))

prec

id <- unique(x = prec[which(diff(x = as.Date(x = prec$date)) == 1), 
                            "id"])

daily <- prec[prec$id %in% id, ]

summary(object = daily)

test <- daily[daily$id == unique(daily$id)[8],]

plot(x = test$date,
     y = test$value, 
     type = "h")

diff(x = test$date)

##
nz <- daily[daily$value > 0,]

