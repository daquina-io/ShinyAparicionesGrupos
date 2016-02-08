library("Imap")
# palacio de los deporte BOG
lon.1 <- -74.08414721488953
lat.1 <- 4.655154449455328
# Plaza de toros Cali
lat.2 <- -76.548445
lon.2 <- 3.409971

 gdist(lon.1, lat.1, lon.2, lat.2, units = "nm", a = 6378137.0, b = 6356752.3142, verbose = FALSE)
# 5497.624

## gdist {Imap} Geodesic distance (great circle distance) between points
## Ellipsoidal.Distance {GEOmap} Ellipsoidal Distance
## deg.dist {fossil} Haversine Distance Formula
## distaz {RSEIS} Distance and Azimuth from two points
## distaz {GEOmap} Distance and Azimuth from two points (# one probably
## borrowed from the other)
## AlongGreat {RFOC} Get Points Along Great Circle
## distAB {clim.pact} Distance between two points on Earth
##  spDists
##   spDistsN1      Euclidean or Great Circle distance between points
## In the sp package.
