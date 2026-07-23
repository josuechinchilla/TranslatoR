#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    fluidPage(
      # Language toggle (top-right). Drives all localized content server-side.
      div(
        class = "topbar",
        div(
          class = "lang-toggle",
          radioButtons(
            "lang", label = NULL,
            choices  = c("English" = "EN", "Español" = "ES"),
            selected = "EN", inline = TRUE
          )
        )
      ),
      uiOutput("app_header"),
      # One module per import template.
      tabsetPanel(
        id = "main_tabs", type = "tabs",
        tabPanel(TEMPLATES$sample$tab,       value = "sample",       mod_sample_ui("sample")),
        tabPanel(TEMPLATES$experimental$tab, value = "experimental", mod_experimental_ui("experimental")),
        tabPanel(TEMPLATES$ontology$tab,     value = "ontology",     mod_ontology_ui("ontology")),
        tabPanel(TEMPLATES$germplasm$tab,    value = "germplasm",    mod_germplasm_ui("germplasm"))
      ),
      uiOutput("footer")
    )
  )
}

#' Add external Resources to the Application
#'
#' Registers the `www/` resource path and bundles everything in
#' `inst/app/www` (including `custom.css`) - the same mechanism Familia uses.
#'
#' @import shiny
#' @importFrom golem add_resource_path favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )
  tags$head(
    tags$meta(charset = "UTF-8"),
    favicon(),
    bundle_resources(
      path      = app_sys("app/www"),
      app_title = "TranslatoR"
    )
  )
}
