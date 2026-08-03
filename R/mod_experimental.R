
#' Experimental tab UI
#'
#' @param id Module id.
#' @return A `uiOutput` placeholder; the localized body is rendered server-side
#'   so it reacts to the app-level language toggle.
#' @noRd
mod_experimental_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::uiOutput(ns("body"))
}

#' Experimental tab server
#'
#' @param id Module id.
#' @param lang A reactive returning the active language ("EN" or "ES").
#' @noRd
mod_experimental_server <- function(id, lang) {
  shiny::moduleServer(id, function(input, output, session) {
    ns       <- session$ns
    template <- TEMPLATES$experimental
    fields   <- template$fields
    tr       <- function(key) L[[lang()]][[key]]

    # Absolute path to a bundled template file in inst/extdata/templates.
    tmpl_path <- function(fname) app_sys("extdata/templates", fname)

    # Persistent upload store (survives language re-renders of the body).
    store <- shiny::reactiveVal(NULL)
    shiny::observeEvent(input$file, {
      shiny::req(input$file)
      store(parse_upload(input$file))
    })

    # -- Localized tab body (bs4Dash panels, Familia mod_ped style) ---------
    output$body <- shiny::renderUI({
      # Per-tab blank-template header - edit / translate freely for this tab.
      blank_title <- if (lang() == "EN") "Download Blank Experiment Template" else "Descargar la plantilla de Experimento en blanco"
      shiny::fluidRow(
          width = 12,
          # --- Blank template ---
          bs4Dash::box(
            title       = shiny::tagList(shiny::icon("download"), " ", blank_title),
            status      = "info", solidHeader = FALSE, width = 12, collapsible = TRUE,
            shiny::tags$p(tr("blank_note"), class = "hint"),
            shiny::div(
              style = "display:flex; gap:10px; flex-wrap:wrap;",
              shiny::downloadButton(ns("blank_en"), tr("blank_en")),
              shiny::downloadButton(ns("blank_es"), tr("blank_es"))
            )
          ),
          # --- Translation Guide: info on the Data sheet (collapsible + maximizable) ---
          bs4Dash::box(
            title       = shiny::tagList(shiny::icon("table"), " ", tr("guide_hdr")),
            status      = "info", solidHeader = FALSE, width = 12,
            collapsible = TRUE, collapsed = TRUE, maximizable = TRUE,
            shiny::tags$p(tr("guide_note"), class = "hint"),
            shiny::tableOutput(ns("guide"))
          ),
          # --- Converter ---
          bs4Dash::box(
            title       = shiny::tagList(shiny::icon("right-left"), " ", tr("conv_hdr")),
            status      = "info", solidHeader = FALSE, width = 12, collapsible = TRUE,
            shiny::radioButtons(
              ns("dir"), tr("dir_label"),
              choices  = stats::setNames(c("es2en", "en2es"),
                                         c(tr("dir_es2en"), tr("dir_en2es"))),
              selected = "es2en"
            ),
            shiny::fileInput(
              ns("file"), tr("upload_label"),
              accept      = c(".xls", ".xlsx", ".csv"),
              buttonLabel = tr("upload_btn"),
              placeholder = tr("upload_ph")
            ),
            shiny::tags$p(tr("only_note"), class = "hint"),
            shiny::downloadButton(ns("dl"), tr("download"), class = "btn btn-primary")
          )
        )
    })

    # -- Translation Guide table (bilingual) --------------------------------
    output$guide <- shiny::renderTable({
      d <- data.frame(
        a = fields$en, b = fields$es,
        c = if (lang() == "EN") fields$desc_en else fields$desc_es,
        d = if (lang() == "EN") fields$req_en  else fields$req_es,
        stringsAsFactors = FALSE)
      names(d) <- c(tr("col_en"), tr("col_es"), tr("col_desc"), tr("col_req"))
      d
    }, striped = TRUE, bordered = TRUE, rownames = FALSE, na = "")

    # -- Download the converted file ----------------------------------------
    output$dl <- shiny::downloadHandler(
      filename = function() {
        cur <- store()
        direction <- if (is.null(input$dir)) "es2en" else input$dir
        suffix <- if (direction == "es2en") "_EN" else "_ES"
        base <- if (!is.null(cur) && !is.null(cur$fname)) tools::file_path_sans_ext(cur$fname) else template$file
        outext <- if (!is.null(cur) && cur$type == "csv") ".csv" else ".xlsx"
        paste0(base, suffix, outext)
      },
      content = function(file) {
        cur <- store()
        shiny::validate(shiny::need(!is.null(cur) && cur$type != "error", tr("err_type")))
        direction <- if (is.null(input$dir)) "es2en" else input$dir
        sheets <- translate_sheets(cur, fields, direction)
        if (cur$type == "csv") {
          utils::write.table(sheets[["Data"]], file, sep = ",", row.names = FALSE,
                             col.names = FALSE, na = "", qmethod = "double",
                             fileEncoding = "UTF-8")
        } else {
          writexl::write_xlsx(sheets, path = file, col_names = FALSE)
        }
      }
    )

    # -- Blank template downloads -------------------------------------------
    # English original, served exactly as shipped in inst/extdata/templates.
    output$blank_en <- shiny::downloadHandler(
      filename = function() template$file,
      content  = function(file) file.copy(tmpl_path(template$file), file, overwrite = TRUE)
    )

    # Fully translated Spanish .xls copy, shipped alongside the English original
    # as "<base>_ES.xls" in inst/extdata/templates - served automatically.
    output$blank_es <- shiny::downloadHandler(
      filename = function() paste0(tools::file_path_sans_ext(template$file), "_ES.xls"),
      content  = function(file) {
        es <- paste0(tools::file_path_sans_ext(template$file), "_ES.xls")
        file.copy(tmpl_path(es), file, overwrite = TRUE)
      }
    )
  })
}

## To be copied in the UI
# mod_experimental_ui("experimental")

## To be copied in the server
# mod_experimental_server("experimental", lang)
