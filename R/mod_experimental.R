#' Experimental tab module
#'
#' Thin wrapper around the shared template_tab_ui / template_tab_server
#' for the Experimental template.
#'
#' @param id Module id.
#' @param lang Reactive returning the active language ("EN"/"ES").
#' @noRd
mod_experimental_ui <- function(id) {
  template_tab_ui(id)
}

#' @noRd
mod_experimental_server <- function(id, lang) {
  template_tab_server(id, TEMPLATES$experimental, lang)
}

## To be copied in the UI
# mod_experimental_ui("experimental")

## To be copied in the server
# mod_experimental_server("experimental", lang)
