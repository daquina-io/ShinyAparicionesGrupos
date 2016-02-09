library(shiny)
library(plotly)
library(leaflet)
#devtools::install_github("ropensci/gistr")
library(gistr)

#grupos_disponibles <- read.csv2("grupos_disponibles.csv", header = FALSE, stringsAsFactors = FALSE)
## grupos_disponibles <- readLines("https://raw.githubusercontent.com/daquina-io/apariciones_abiertas/master/proyectos_ordenados_desc.txt")

source_GitHubData <-function(url, sep = ",", header = TRUE)
{
  require(httr)
  request <- GET(url)
  stop_for_status(request)
  handle <- textConnection(content(request, as = 'text'))
  on.exit(close(handle))
  read.table(handle, sep = sep, header = FALSE, stringsAsFactors = FALSE)
}

grupos_disponibles <- source_GitHubData("https://raw.githubusercontent.com/daquina-io/apariciones_abiertas/master/proyectos_ordenados_desc.txt")
colnames(grupos_disponibles) <- "Agrupaciones"

# Define UI for dataset viewer application
shinyUI(fluidPage(

  # Application title
  titlePanel("Apariciones de agrupaciones musicales"),

  sidebarLayout(
      sidebarPanel(
          fluidRow(
              column(7,
                     selectizeInput('grupos', 'Seleccione los grupos que quiere analizar', choices = grupos_disponibles, multiple = TRUE )),
              column(1,
                     submitButton("Mostrar información"))
              )
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
