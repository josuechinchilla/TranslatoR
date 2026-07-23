#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  options(shiny.maxRequestSize = 100 * 1024^2)

  # App-level language state, shared with every module.
  lang <- reactive({ if (is.null(input$lang)) "EN" else input$lang })

  # One module server per tab.
  mod_Home_server("home", lang)
  mod_sample_server("sample", lang)
  mod_experimental_server("experimental", lang)
  mod_ontology_server("ontology", lang)
  mod_germplasm_server("germplasm", lang)
}
