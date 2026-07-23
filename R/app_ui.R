#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom bs4Dash bs4DashPage bs4DashNavbar bs4DashSidebar sidebarMenu menuItem dashboardBody tabItems tabItem box dashboardFooter
#'
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    tags$head(tags$style(HTML(sprintf(
      ":root { --sidebar-core: var(--%s-core); --sidebar-lite: var(--%s-lite); --sidebar-deep: var(--%s-deep); }",
      "purple", "purple", "purple"
    )))),
    bs4DashPage(
      skin = "black",
      bs4DashNavbar(
        title = tagList(
          tags$img(src = "www/logos2.png", height = "40")
        ),
        rightUi = tags$li(
          class = "dropdown",
          div(
            class = "navbar-lang",
            radioButtons(
              "lang", label = NULL,
              choices  = c("English" = "EN", "Español" = "ES"),
              selected = "EN", inline = TRUE
            )
          )
        ),
        help = NULL
      ),
      bs4DashSidebar(
        skin          = "light",
        status        = "primary",
        fixed         = TRUE,
        expandOnHover = TRUE,
        sidebarMenu(
          id   = "MainMenu",
          flat = FALSE,
          tags$li(class = "header", style = "color: grey; margin-top: 10px; margin-bottom: 10px; padding-left: 15px;", "Menu"),
          menuItem("Home · Inicio", tabName = "home", icon = icon("house"), startExpanded = FALSE),
          tags$li(class = "header", style = "color: grey; margin-top: 18px; margin-bottom: 10px; padding-left: 15px;", "Templates · Plantillas"),
          menuItem("Samples · Muestras",       tabName = "sample",       icon = icon("vial")),
          menuItem("Experiment · Experimento", tabName = "experimental", icon = icon("flask")),
          menuItem("Ontology · Ontología",     tabName = "ontology",     icon = icon("sitemap")),
          menuItem("Germplasm · Germoplasma",  tabName = "germplasm",    icon = icon("seedling")),
          tags$li(class = "header", style = "color: grey; margin-top: 18px; margin-bottom: 10px; padding-left: 15px;", "Information"),
          menuItem("Source Code", icon = icon("circle-info"), href = "https://github.com/josuechinchilla/TranslatoR")
        )
      ),
      footer = dashboardFooter(
        right = div(
          style = "display: flex; align-items: center;",
          div(
            style = "display: flex; flex-direction: column; margin-right: 15px; text-align: right;",
            div("2026 Breeding Insight"),
            div("DeltaBreed import templates")
          ),
          div(
            tags$img(src = "www/logos2.png", height = "40px")
          )
        ),
        left = div(
          style = "display: flex; align-items: center; height: 100%;",
          sprintf("v%s", as.character(utils::packageVersion("TranslatoR")))
        )
      ),
      dashboardBody(
        tabItems(
          tabItem(tabName = "home",         mod_Home_ui("home")),
          tabItem(tabName = "sample",       mod_sample_ui("sample")),
          tabItem(tabName = "experimental", mod_experimental_ui("experimental")),
          tabItem(tabName = "ontology",     mod_ontology_ui("ontology")),
          tabItem(tabName = "germplasm",    mod_germplasm_ui("germplasm"))
        )
      )
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
