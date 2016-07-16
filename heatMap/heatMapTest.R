library(rMaps)
library(RJSONIO)
source("../utils.R")
L2 <- Leaflet$new()
L2$setView(c(29.7632836, -95.3632715), 10)
# ERROR: MapQuestOpen cambio sus políticas de uso, hay una alternativa?
L2$tileLayer(provider = "MapQuestOpen.OSM")


# ------ data crime ---------
data(crime, package = 'ggmap')
library(plyr)
crime_dat = ddply(crime, .(lat, lon), summarise, count = length(address))
crime_dat = toJSONArray2(na.omit(crime_dat), json = F, names = F)
cat(rjson::toJSON(crime_dat[1:2]))

# !!! formato de los datos !!!
# [[27.5071143,-99.5055471,1],[29.4836146,-95.0618715,10]]

# ------- datos fonseca --------------
# TODO: extraer los campos lat, log y capacity de este geoJson : https://github.com/daquina-io/apariciones/blob/master/fonseca.geojson)) y que quede formateados así:
# [[27.5071143,-99.5055471,1],[29.4836146,-95.0618715,10]]
geojson <- fromJSON("https://raw.githubusercontent.com/daquina-io/apariciones/master/fonseca.geojson")
geojson

# Add leaflet-heat plugin. Thanks to Vladimir Agafonkin
L2$addAssets(jshead = c(
  "http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"


# Add javascript to modify underlying chart
L2$setTemplate(afterScript = sprintf("
<script>
  var addressPoints = %s
  var heat = L.heatLayer(addressPoints).addTo(map)           
</script>
", rjson::toJSON(crime_dat)
))

L2
