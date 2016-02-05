library(shiny)
library(plotly)
library(leaflet)

grupos_disponibles <- read.csv2("grupos_disponibles.csv", header = FALSE, stringsAsFactors = FALSE)
colnames(grupos_disponibles) <- "Agrupaciones"

## grupos_disponibles <- readLines("https://raw.githubusercontent.com/daquina-io/apariciones_abiertas/master/proyectos_ordenados_desc.txt")


# Define UI for dataset viewer application
shinyUI(fluidPage(

  # Application title
  titlePanel("Apariciones de agrupaciones musicales"),

  sidebarLayout(
    sidebarPanel(
        selectizeInput('grupos', 'Seleccione los grupos que quiere analizar', choices = grupos_disponibles, multiple = TRUE ),
        submitButton("Mostrar información")
    ),

      mainPanel(
          tabsetPanel(
              tabPanel("Gráfico fecha/Capacidad", plotlyOutput("apariciones_bubbles")),
              tabPanel("Gráfico Tendencia fecha/Capacidad", plotOutput("apariciones_tendencia")),
              tabPanel("Mapa", leafletOutput("apariciones_mapa")),
              tabPanel("Tabla de datos", DT::dataTableOutput("tabla"))
            )
        )
      )
    ))
