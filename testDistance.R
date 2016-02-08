library("Imap")
# palacio de los deporte BOG
lon.1 <- -74.08414721488953
lat.1 <- 4.655154449455328
# Plaza de toros Cali
lat.2 <- -76.548445
lon.2 <- 3.409971

 gdist(lon.1, lat.1, lon.2, lat.2, units = "nm", a = 6378137.0, b = 6356752.3142, verbose = FALSE)
# 5497.624
