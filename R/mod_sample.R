#' Sample Submission tab module
#'
#' Thin wrapper around the shared [template_tab_ui()] / [template_tab_server()]
#' for the Sample Submission template.
#'
#' @param id Module id.
#' @param lang Reactive returning the active language ("EN"/"ES").
#' @noRd
mod_sample_ui <- function(id) {
  template_tab_ui(id)
}

#' @noRd
mod_sample_server <- function(id, lang) {
  template_tab_server(id, TEMPLATES$sample, lang)
}

## To be copied in the UI
# mod_sample_ui("sample")

## To be copied in the server
# mod_sample_server("sample", lang)
