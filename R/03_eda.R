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

object.size(x = dta)

str(object = dta)

prec <- dta[dta$variable == "rain", c("date", "value", "location", "reg_id")]

unique(x = prec$location)

diff(x = as.Date(x = prec$date))

prec

## aggregate the stations in daily steps to mothly data

stations <- unique(x = prec[which(diff(x = as.Date(x = prec$date)) == 1), 
                            "location"])

daily <- prec[prec$location %in% stations, ]

# x <- diff(x = daily$date)
# table(x = x)
# 
# monthly <- prec[diff(x = as.Date(x = prec$date)) != 1, ] 
# 
# 
# # aggregate.data.frame(x = daily,
# #                      by = list(months = format(x = daily$date,
# #                                                format = "%Y-%m")),
# #                      FUN = sum)
# 
# aux <- split(x = daily, 
#              f =  format(x = daily$date,
#                          format = "%Y-%m"))
# m <- lapply(X = aux, 
#             FUN = function(x) {
#               
#               x <- aux[[1]]
#               
#               data.frame(date = x$date[1], 
#                          value = sum(x = x$value, 
#                                      na.rm = TRUE), 
#                          location = unique(x = x$location))
#             })
# 
# do.call(what = rbind, 
#         args = m)

summary(object = daily)

test <- daily[daily$location == "Bílý Kříž",]

plot(x = test$date,
     y = test$value, 
     type = "h")

diff(x = test$date)

##
unique(x = daily[, c("location", "reg_id")])

nz <- daily[daily$value > 0,]

nz_l <- split(x = nz,
              f = nz$location)

sapply(
  X = nz_l, 
  FUN = function(x) {
    
    c("mean" = mean(x = x$value,
                    na.rm = TRUE),
      "sd" = sd(x = x$value,
                na.rm = TRUE))
  }
)
