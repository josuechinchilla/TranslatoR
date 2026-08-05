#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @noRd
app_ui <- function(request) {
  # Bilingual sidebar label: both languages are rendered; CSS shows the one that
  # matches the active language (toggled by a body class - see custom.css / JS).
  bil <- function(en, es) shiny::HTML(paste0(
    "<span class='l-en'>", en, "</span><span class='l-es'>", es, "</span>"))
  shiny::tagList(
    golem_add_external_resources(),
    shiny::tags$head(shiny::tags$style(shiny::HTML(sprintf(
      ":root { --sidebar-core: var(--%s-core); --sidebar-lite: var(--%s-lite); --sidebar-deep: var(--%s-deep); }",
      "purple", "purple", "purple"
    )))),
    bs4Dash::bs4DashPage(
      skin = "black",
      dark = FALSE,   # keep the light/dark appearance switch (default light)
      help = NULL,    # remove the unused help toggle switch
      bs4Dash::bs4DashNavbar(
        title = shiny::tagList(
          shiny::tags$img(src = "www/translator_logo_stacked.svg", height = "100")
        ),
        rightUi = shiny::tags$li(
          class = "dropdown",
          shiny::div(
            class = "navbar-lang",
            shiny::radioButtons(
              "lang", label = NULL,
              choices  = c("English" = "EN", "Español" = "ES"),
              selected = "EN", inline = TRUE
            )
          )
        ),
        help = NULL
      ),
      bs4Dash::bs4DashSidebar(
        skin          = "light",
        status        = "primary",
        fixed         = TRUE,
        expandOnHover = TRUE,
        bs4Dash::sidebarMenu(
          id   = "MainMenu",
          flat = FALSE,
          shiny::tags$li(class = "header", style = "color: grey; margin-top: 10px; margin-bottom: 10px; padding-left: 15px;", bil("Menu", "Menú")),
          bs4Dash::menuItem(bil("Home", "Inicio"), tabName = "home", icon = shiny::icon("house"), startExpanded = FALSE),
          shiny::tags$li(class = "header", style = "color: grey; margin-top: 18px; margin-bottom: 10px; padding-left: 15px;", bil("Templates", "Plantillas")),
          bs4Dash::menuItem(bil("Experiments", "Experimentos"), tabName = "experimental", icon = shiny::icon("flask")),
          bs4Dash::menuItem(bil("Germplasm", "Germoplasma"),  tabName = "germplasm",    icon = shiny::icon("sitemap")),
          bs4Dash::menuItem(bil("Ontology", "Ontología"),     tabName = "ontology",     icon = shiny::icon("clipboard-list")),
          bs4Dash::menuItem(bil("Sample Submission", "Envío de Muestra"),       tabName = "sample",       icon = shiny::icon("dna")),
          shiny::tags$li(class = "header", style = "color: grey; margin-top: 18px; margin-bottom: 10px; padding-left: 15px;", "DeltaBreed Links"),
          bs4Dash::menuItem(bil("Help Materials", "Materiales de Apoyo"), icon = shiny::icon("circle-info"), href = "https://breedinginsight.org/learning-hub/deltabreed/"),
          bs4Dash::menuItem(bil("Production Server", "Servidor de Producción"), icon = shiny::icon("circle-info"), href = "https://app.breedinginsight.net/"),
          bs4Dash::menuItem(bil("Sandbox Server", "Servidor de Entrenamiento"), icon = shiny::icon("circle-info"), href = "https://sandbox.breedinginsight.net/")
        )
      ),
      footer = bs4Dash::dashboardFooter(
        right = shiny::div(
          style = "display: flex; align-items: center;",
          shiny::div(
            style = "display: flex; flex-direction: column; margin-right: 15px; text-align: right;",
            shiny::div("2026 Breeding Insight"),
          ),
          shiny::div(
            shiny::tags$img(src = "www/logos2.png", height = "65px")
          )
        ),
        left = shiny::div(
          style = "display: flex; align-items: center; height: 100%;",
          sprintf("v%s", as.character(utils::packageVersion("TranslatoR")))
        )
      ),
      bs4Dash::dashboardBody(
        bs4Dash::tabItems(
          bs4Dash::tabItem(tabName = "home",         mod_Home_ui("home")),
          bs4Dash::tabItem(tabName = "sample",       mod_sample_ui("sample")),
          bs4Dash::tabItem(tabName = "experimental", mod_experimental_ui("experimental")),
          bs4Dash::tabItem(tabName = "ontology",     mod_ontology_ui("ontology")),
          bs4Dash::tabItem(tabName = "germplasm",    mod_germplasm_ui("germplasm"))
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
#' @noRd
golem_add_external_resources <- function() {
  golem::add_resource_path(
    "www",
    app_sys("app/www")
  )
  shiny::tags$head(
    shiny::tags$meta(charset = "UTF-8"),
    golem::favicon(),
    golem::bundle_resources(
      path      = app_sys("app/www"),
      app_title = "TranslatoR"
    ),
    # Toggle a body class so bilingual labels switch with the language radio.
    shiny::tags$script(shiny::HTML(
      "$(document).on('shiny:inputchanged', function(e){ if (e.name === 'lang') { document.body.classList.toggle('lang-es', e.value === 'ES'); } });"
    ))
  )
}
