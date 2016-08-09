library(shiny)
library(plotly)
library(leaflet)
## devtools::install_github("ropensci/gistr")
## devtools::install_github('rstudio/DT')
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
                     selectizeInput('grupos', 'Seleccione los grupos que quiere analizar', choices = grupos_disponibles, multiple = TRUE, selected = "fonseca" )),
              column(1,
                     submitButton("Mostrar información"))
              ),
          fluidRow( column(12,
              h3("Datos abiertos sobre apariciones de proyectos musicales"),
                           p("Planteamos una forma colaborativa de recoger información de la escena musical, inicialmente las apariciones de proyectos musicales usando un repositorio distribuído donde todos podemos aportar; de allí es donde proviene toda la información que vez acá de manera visual."),
                           p("Puedes acceder directamente a la información en el repositorio", a(href="https://github.com/daquina-io/apariciones","https://github.com/daquina-io/apariciones"), "la cual fue creada usando", a(href="http://geojson.io/","http://geojson.io/") ),
                           p("De igual manera puedes ver el código fuente de las visualizaciones disponibles en el panel derecho en el siguiente repositorio", a(href = "https://github.com/daquina-io/visualizacion_apariciones_proyectos_musicales","https://github.com/daquina-io/visualizacion_apariciones_proyectos_musicales")),
                           p("Nos puedes contactar en el correo electrónico", a(href="mailto:daquinacol@gmail.com?Subject=He%20visto%20la%20visualización%20y%20...","daquinacol@gmail.com") )
              ))
          ),

      mainPanel(
        tabsetPanel(
              tabPanel("Mapa", leafletOutput("apariciones_mapa")),
              tabPanel("Gráfico fecha/Capacidad", plotlyOutput("apariciones_bubbles")),
              tabPanel("Gráfico Tendencia fecha/Capacidad", plotOutput("apariciones_tendencia")),
              tabPanel("Tabla de datos", DT::dataTableOutput("tabla"))
            )
        )
      )
    ))
