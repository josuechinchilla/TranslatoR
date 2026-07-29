#' Ontology tab module
#'
#' Thin wrapper around the shared template_tab_ui/template_tab_server
#' for the Ontology template.
#'
#' @param id Module id.
#' @param lang Reactive returning the active language ("EN"/"ES").
#' @noRd
mod_ontology_ui <- function(id) {
  template_tab_ui(id)
}

#' @noRd
mod_ontology_server <- function(id, lang) {
  template_tab_server(id, TEMPLATES$ontology, lang)
}

## To be copied in the UI
# mod_ontology_ui("ontology")

## To be copied in the server
# mod_ontology_server("ontology", lang)
