#' Home tab module
#'
#' Welcome page laid out like the Familia Home page: an app-description box, an
#' "About Breeding Insight" box, and a column of link cards plus the Breedverse
#' box. All text is localized (EN/ES) via the app-level language toggle.
#' Replace the placeholder link `href`s.
#'
#' @param id Module id.
#' @param lang Reactive returning the active language ("EN"/"ES").
#' @noRd
mod_Home_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::uiOutput(ns("home_body"))
}

#' @noRd
mod_Home_server <- function(id, lang) {
  shiny::moduleServer(id, function(input, output, session) {

    output$home_body <- shiny::renderUI({
      en <- lang() == "EN"

      # ---- Column 1: what the app does ----
      app_title <- if (en) {
        "TranslatoR: Breeding Insight Template Translator"
      } else {
        "TranslatoR: Traductor de plantillas de Breeding Insight"
      }
      app_desc <- if (en) {
        "<p>TranslatoR converts DeltaBreed import templates from English to Spanish and vice-versa. 
        Only the <b>Data-sheet headers</b> are translated — your data stays exactly as you entered them..</p>
         <p><b>With TranslatoR you can:</b></p>
         <ul>
           <li>Download DeltaBreed import templates in English or Spanish</li>
           <li>Read a bilingual Translation Guide for every column</li>
           <li>Convert a filled-in template between Spanish and English</li>
         </ul>
         <p>PChoose the template you need from the menu on the left. <p>
        <p>To change the language for the app, toggle English / Español at the top right.</p>"
        
      } else {
        "<p>TranslatoR traduce las plantillas de importación de Breeding Insight / DeltaBreed
          entre español e inglés. Solo se traducen los <b>encabezados de columna de la hoja
          Data</b>; sus datos permanecen tal como los ingresó.</p>
         <p><b>Con TranslatoR puede:</b></p>
         <ul>
           <li>Descargar una plantilla en blanco (original en inglés o en español)</li>
           <li>Consultar una Guía de Traducciones para cada columna</li>
           <li>Convertir una plantilla completada entre español e inglés</li>
         </ul>
         <p>Elija una plantilla en el menú de la izquierda. <p>
         <p>Use el interruptor <b>English / Español</b> en la parte superior derecha para cambiar el idioma.</p>"
      }

      # ---- Column 2: About Breeding Insight ----
      about_title <- if (en) "About Breeding Insight" else "Acerca de Breeding Insight"
      about_body <- if (en) {
        "We provide scientific consultation and data management software to the specialty crop and animal breeding communities.
        <ul>
          <li>Genomics</li>
          <li>Phenomics</li>
          <li>Data Management</li>
          <li>Software Tools</li>
          <li>Analysis</li>
        </ul>
        Breeding Insight is funded by the U.S. Department of Agriculture (USDA) Agricultural Research Service (ARS) through University of Florida.
        <div style='text-align: center; margin-top: 20px;'>
          <img src='www/BreedingInsight.png' alt='Breeding Insight' style='width: 85px; height: 85px;'>
        </div>"
      } else {
        "Ofrecemos consultoría científica y software de gestión de datos a las comunidades de mejoramiento de cultivos especiales y de animales.
        <ul>
          <li>Genómica</li>
          <li>Fenómica</li>
          <li>Gestión de datos</li>
          <li>Herramientas de software</li>
          <li>Análisis</li>
        </ul>
        Breeding Insight cuenta con el financiamiento del Servicio de Investigación Agrícola (ARS) del Departamento de Agricultura de los EE. UU. (USDA) a través de la Universidad de Florida
        <div style='text-align: center; margin-top: 20px;'>
          <img src='www/BreedingInsight.png' alt='Breeding Insight' style='width: 85px; height: 85px;'>
        </div>"
      }

      # ---- Column 3: link cards + Breedverse ----
      lbl_learn    <- if (en) "Learn More About Breeding Insight" else "Conozca más sobre Breeding Insight"
      lbl_contact  <- if (en) "Contact Us" else "Contáctenos"
      lbl_tutorial <- if (en) "TranslatoR Tutorial" else "Tutorial de TranslatoR"
      bv_title     <- if (en) "Try the Breedverse!" else "¡Pruebe el Breedverse!"
      bv_body <- if (en) {
        "We developed an R shiny interface where you can use ALL of our Breeding Insight applications in a single location. This
         includes applications like BIGapp, Qploidy, and GenoBrew, PLUS all of our newly released applications.
         Learn more and see install instructions here
          <div style='text-align: center; margin-top: 20px;'>
            <img src='www/breedverse_logo.png' alt='Breedverse' style='width: 120px; height: 140px;'>
          </div>"
      } else {
        "Desarrollamos una interfaz de R Shiny donde puede usar TODAS nuestras aplicaciones de Breeding Insight en un solo lugar. Esto
         incluye aplicaciones como BIGapp, Qploidy y GenoBrew, ADEMÁS de todas nuestras aplicaciones recién lanzadas.
         Conozca más y vea las instrucciones de instalación aquí
          <div style='text-align: center; margin-top: 20px;'>
            <img src='www/breedverse_logo.png' alt='Breedverse' style='width: 120px; height: 140px;'>
          </div>"
      }

      shiny::fluidRow(
        shiny::column(
          width = 4,
          bs4Dash::box(
            title = app_title, status = "info", solidHeader = FALSE, width = 12, collapsible = FALSE,
            shiny::HTML(app_desc),
            style = "overflow-y: auto; height: 500px"
          )
        ),
        shiny::column(
          width = 4,
          bs4Dash::box(
            title = about_title, status = "success", solidHeader = FALSE, width = 12, collapsible = FALSE,
            shiny::HTML(about_body),
            style = "overflow-y: auto; height: 500px"
          )
        ),
        shiny::column(
          width = 4,
          # ---- EDIT THESE LINKS: replace href = "#" with real URLs ----
          shiny::tags$a(
            href = "https://www.breedinginsight.org", target = "_blank",
            bs4Dash::valueBox(
              value = NULL, subtitle = lbl_learn,
              icon = shiny::icon("link"), color = "purple", gradient = TRUE, width = 11
            ),
            style = "text-decoration: none; color: inherit;"
          ),
          shiny::tags$a(
            href = "https://breedinginsight.org/contact-us/", target = "_blank",
            bs4Dash::valueBox(
              value = NULL, subtitle = lbl_contact,
              icon = shiny::icon("envelope"), color = "danger", gradient = TRUE, width = 11
            ),
            style = "text-decoration: none; color: inherit;"
          ),
          #shiny::tags$a(
           # href = "#", target = "_blank",
            #bs4Dash::valueBox(
             # value = NULL, subtitle = lbl_tutorial,
              #icon = shiny::icon("compass"), color = "info", gradient = TRUE, width = 11
            #),
            #style = "text-decoration: none; color: inherit;"
          #),
          bs4Dash::box(
            title = bv_title, status = "warning", solidHeader = TRUE, width = 11, collapsible = FALSE,
            shiny::HTML(bv_body),
            style = "overflow-y: auto; height: 300px"
          )
        )
      )
    })
  })
}

## To be copied in the UI
# mod_Home_ui("home")

## To be copied in the server
# mod_Home_server("home", lang)
