#' Germplasm Import tab module
#'
#' Thin wrapper around the shared [template_tab_ui()] / [template_tab_server()]
#' for the Germplasm Import template.
#'
#' @param id Module id.
#' @param lang Reactive returning the active language ("EN"/"ES").
#' @noRd
mod_germplasm_ui <- function(id) {
  template_tab_ui(id)
}

#' @noRd
mod_germplasm_server <- function(id, lang) {
  template_tab_server(id, TEMPLATES$germplasm, lang)
}

## To be copied in the UI
# mod_germplasm_ui("germplasm")

## To be copied in the server
# mod_germplasm_server("germplasm", lang)
