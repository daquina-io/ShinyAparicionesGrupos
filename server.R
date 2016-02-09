library(shiny)
library(jsonlite)
library(plyr)
library(stringr)
library(stringi)
library(ggplot2)
library(plotly)
library(lubridate)
library(leaflet)
library(RColorBrewer)
source("./utils.R")

shinyServer(function(input, output, session) {

  output$grupos <- renderPrint({
      input$grupos
  })

  data <- reactive({
      mapas <- lapply(setNames(input$grupos, input$grupos), function(x) get_raw_geojson("daquina-io/apariciones_proyectos_musicales",x))
      flatten_data <- flat_data(mapas)
      colnames(flatten_data) <- normalizarNombre(colnames(flatten_data))
      flatten_data
  })

  output$tabla <- DT::renderDataTable(
    DT::datatable({
        data()
    }))

  output$apariciones_bubbles <- renderPlotly({
      b <- ggplot(data(), aes(x = ymd(Date), y = as.numeric(Capacity), size = Capacity, colour = Id)) + geom_point(stat = "identity") + xlab("Fecha") + ylab("Capacidad") + labs(title = "Apariciones")
b
      (gg <- ggplotly(b))
  })

  output$apariciones_tendencia <- renderPlot({
      b <- ggplot(data(), aes(x = ymd(Date), y = as.numeric(Capacity))) + geom_smooth(method = "loess", formula = y ~ x, span = 0.4) + geom_point() + xlab("Fecha") + ylab("Capacidad") + labs(title = "Apariciones") + facet_wrap("Id")
      b
      #(gg <- ggplotly(b))
  })

  output$apariciones_mapa <- renderLeaflet({
      df <- data()
      grupos_seleccionados <- unique(df$Id)
      factpal <- colorFactor(topo.colors(length(grupos_seleccionados)), grupos_seleccionados)

      leaflet(data = df) %>% addTiles() %>%
      #addMarkers(~X, ~Y, popup = ~as.character(Venue)) %>%
      addCircles(~X, ~Y, popup = ~as.character(Venue), fillOpacity = 0.7, radius = ~log(Capacity*10), color = ~factpal(Id)) %>%
      addLegend("bottomright", pal = factpal, values = ~Id, title = "Apariciones", opacity = 1)
  })

})
