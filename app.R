# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue "Run App" button at the top of this file in RStudio.

pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)
options("golem.app.prod" = TRUE, shiny.autoload.r = FALSE)
run_app() # add parameters here (if any)  -- unqualified so rsconnect doesn't try to snapshot TranslatoR itself
