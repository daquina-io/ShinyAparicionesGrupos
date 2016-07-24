##library(devtools)
##install_github("ramnathv/rCharts@dev")
library(rMaps)
library(RJSONIO)
library(jsonlite)
# trae los datos
geojson <- jsonlite::fromJSON("https://raw.githubusercontent.com/daquina-io/apariciones/master/fonseca.geojson")
str(geojson)
# extrae latitud y longitud
coordinates <- matrix(unlist(geojson$features$geometry$coordinates), ncol = 2, byrow = TRUE)
 # invierte lat y long
coordinates2 <- coordinates[,c(2,1)]
# extrae capacity
capacity <- matrix(unlist(geojson$features$properties$capacity), ncol = 1, byrow = TRUE)
capacity <- as.numeric(capacity)
# une lat long y capacity
coordinatesCapacity <- cbind(coordinates2,capacity)
# inicia Leaflet
L2 <- Leaflet$new()
L2$setView(c(4.657699484508704, -74.09591674804688 ), 5)
# Add leaflet-heat plugin. Thanks to Vladimir Agafonkin
L2$addAssets(jshead = c(
  "http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"
))
# Add javascript to modify underlying chart
L2$setTemplate(afterScript = sprintf("
<script>
  var addressPoints = %s
  var heat = L.heatLayer(addressPoints).addTo(map)           
</script>
", coordinates
))
L2
 # adaptación de ejemplo http://www.d3noob.org/2014/02/generate-heatmap-with-leafletheat-and.html
addressPoints <- data.frame( coordinatesCapacity  )
colnames( addressPoints ) <- c( "lat", "lng", "value" )

earthquakes = data.frame( addressPoints  )
leaflet( earthquakes ) %>%
  addTiles() %>%
  setView( -74.5546,4.646, 5 ) %>%
  addHeatmap(
    lat = ~lat,
    lng = ~lng,
    intensity = ~value,
    radius = 20,
    blur = 15,
    maxZoom = 17
  )

#  using data(quakes)
data(quakes)

leaflet(quakes) %>%
  addTiles( ) %>%
  setView( 178, -20, 5 ) %>%
  addHeatmap( lng = ~long, intensity = ~mag,
              blur = 20, max = 0.02, radius = 10,
             gradient = "Greys" )

leaflet()


##################################################################################################
################ https://github.com/rstudio/leaflet/pull/174 #####################################
##################################################################################################
# Or Github version
if (!require('devtools')) install.packages('devtools')
devtools::install_github('rstudio/leaflet@feature/heatmap')

library(leaflet)

# match the heatmap demo from Leaflet.heat
# https://github.com/Leaflet/Leaflet.heat/blob/gh-pages/demo/index.html

# get the data to match exactly
addressPoints <- readLines(
  "http://leaflet.github.io/Leaflet.markercluster/example/realworld.10000.js"
)
addressPoints <- apply(
  jsonlite::fromJSON(
    sprintf("[%s]",
      paste0(
        addressPoints[4:(length(addressPoints)-1)]
        ,collapse=""
      )
    )
  )
  ,MARGIN = 2
  ,as.numeric
)

 addressPoints <- data.frame( addressPoints )
addressPoints <- data.frame( coordinatesCapacity  )
colnames( addressPoints ) <- c( "lat", "lng", "value" )

# create our heatmap
leaf <- leaflet( addressPoints ) %>%
  setView( 4.657699484508704, -74.09591674804688 , 5 ) %>%
  addHeatmap(intensity=~value )

leaf

# or create a dot map-like heatmap
# create our heatmap
leaflet( addressPoints ) %>% addTiles() %>%
  setView( 4.657699484508704, -74.09591674804688 , 5 ) %>%
  addHeatmap(intensity=~value, radius = 2, blur = 1,
             max = 1e-10, gradient = blues9[8:9] )

# customize our heatmap with options
leaf <- leaflet() %>%
  addTiles() %>%
  setView( 4.657699484508704, -74.09591674804688 , 5 ) %>%
  addHeatmap(
    data = addressPoints,
    intensity = ~value,
    blur = 50,
    gradient = "Purples"
  )


leaf

# replicate the example provided by
#   http://www.d3noob.org/2014/02/generate-heatmap-with-leafletheat-and.html

earthquakes <- readLines(
  "http://bl.ocks.org/d3noob/raw/8973028/2013-earthquake.js"
)
earthquakes <- apply(
  jsonlite::fromJSON(
    sprintf("[%s]",
            paste0(
              earthquakes[5:(length(earthquakes)-1)]
              ,collapse=""
            )
    )
  )
  ,MARGIN = 2
  ,as.numeric
)

earthquakes = data.frame( addressPoints  )
leaflet( earthquakes ) %>%
  addTiles() %>%
  setView( 174.146, -41.5546, 10 ) %>%
  addHeatmap(
    lat = ~X1,
    lng = ~X2,
    intensity = ~X3,
    radius = 20,
    blur = 15,
    maxZoom = 17
  )

#  using data(quakes)
data(quakes)

leaflet(quakes) %>%
  addTiles( ) %>%
  setView( 178, -20, 5 ) %>%
  addHeatmap( lng = ~long, intensity = ~mag,
              blur = 20, max = 0.02, radius = 10,
             gradient = "Greys" )

leaflet()

# to remove the heatmap
leaf %>% clearHeatmap()
