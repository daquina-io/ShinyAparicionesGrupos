##if (!require("devtools"))
##  install.packages("devtools")
##devtools::install_github("rstudio/shiny")
library(shiny)
library(jsonlite)
library(plyr)
library(stringr)
library(stringi)
library(ggplot2)
## devtools::install_github("ropensci/plotly")
library(plotly)
library(lubridate)
library(leaflet)
library(RColorBrewer)
source("./utils.R")

# https://github.com/SocialFunction/youTubeDataR
# devtools::install_github("SocialFunction/youTubeDataR")

shinyServer(function(input, output, session) {

  output$grupos <- renderPrint({
      input$grupos
  })

  data <- reactive({
      mapas <- lapply(setNames(input$grupos, input$grupos), function(x) get_raw_geojson("daquina-io/apariciones_proyectos_musicales",x))
      flatten_data <- flat_data(mapas)
      colnames(flatten_data) <- normalizarNombre(colnames(flatten_data))
      flatten_data$Date <- normalizar_fecha(flatten_data$Date)
      flatten_data
  })

  output$tabla <- DT::renderDataTable(
    DT::datatable({
        data()
    }))

  output$apariciones_bubbles <- renderPlotly({

      b <- ggplot(data(), aes(x = Date, y = as.numeric(Capacity), size = Capacity, colour = Id)) + geom_point(stat = "identity") + xlab("Fecha") + ylab("Capacidad") + labs(title = "Apariciones")
b
      (gg <- ggplotly(b))
  })

  output$apariciones_tendencia <- renderPlot({
      b <- ggplot(data(), aes(x = Date, y = as.numeric(Capacity))) + geom_smooth(method = "loess", formula = y ~ x, span = 0.4) + geom_point() + xlab("Fecha") + ylab("Capacidad") + labs(title = "Apariciones") + facet_wrap("Id")
      b
      #(gg <- ggplotly(b))
  })

  output$apariciones_mapa <- renderLeaflet({
      df <- data()
      grupos_seleccionados <- unique(df$Id)
      factpal <- colorFactor(topo.colors(length(grupos_seleccionados)), grupos_seleccionados)
      factor_pondera <- 1.5

      maximo <- max(df$Capacity)
      minimo <- min(df$Capacity)


      leaflet(data = df) %>% addTiles() %>%
        addCircles(~X, ~Y, popup = ~as.character(Venue), fillOpacity = 0.7, radius = ~log(Capacity*10), color = ~factpal(Id)) %>%
        addHeatmap(
          lat = ~Y,
          lng = ~X,
          intensity = ~Capacity*factor_pondera/(maximo-minimo),
          radius = 20,
          blur = 15,
          maxZoom = 17
        ) %>%
      #addMarkers(~X, ~Y, popup = ~as.character(Venue)) %>%
      addLegend("bottomright", pal = factpal, values = ~Id, title = "Apariciones", opacity = 1)
  })

})
