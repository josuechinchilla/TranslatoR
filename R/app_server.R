#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  options(shiny.maxRequestSize = 100 * 1024^2)

  # App-level language state, shared with every tab module.
  lang <- reactive({ if (is.null(input$lang)) "EN" else input$lang })
  tr   <- function(key) L[[lang()]][[key]]

  # Localized header
  output$app_header <- renderUI({
    tagList(
      tags$h2(tr("title"),
              style = "font-size:24px; text-align:left; margin:6px 0 2px 0; font-weight:normal;"),
      tags$p(tr("subtitle"), class = "hint", style = "margin-bottom:4px;")
    )
  })

  # Page footer with the BI logo, served from www/ (same approach as Familia).
  output$footer <- renderUI({
    tags$div(
      class = "app-footer",
      tags$hr(),
      tags$img(src = "www/logos2.png", alt = "Breeding Insight", height = "72px")
    )
  })

  # One module server per import template.
  mod_sample_server("sample", lang)
  mod_experimental_server("experimental", lang)
  mod_ontology_server("ontology", lang)
  mod_germplasm_server("germplasm", lang)
}
