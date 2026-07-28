# TranslatoR

A `{golem}` + `{bs4Dash}` Shiny application, laid out like the Familia app, that
switches Breeding Insight / DeltaBreed import templates between **Spanish and
English**. A left sidebar navigates a Home page plus one module per import template.
Only the **Data-sheet column headers** are translated — every data value and every
other worksheet is copied through untouched.

## Run it

```r
# install once
install.packages(c("shiny", "bs4Dash", "golem", "config", "readxl", "writexl", "pkgload"))

# from the package root:
pkgload::load_all()
run_app()
# or open app.R in RStudio and click "Run App"
```

Deploy the same way as Familia (e.g. `rsconnect::deployApp()`).

## Package structure (golem)

```
TranslatoR/
├── app.R                       # launcher: pkgload::load_all(); run_app()
├── DESCRIPTION / NAMESPACE
├── R/
│   ├── app_config.R            # app_sys(), get_golem_config()
│   ├── run_app.R               # run_app() -> shinyApp(app_ui, app_server)
│   ├── app_ui.R                # bs4Dash shell (navbar + sidebar + tabItems + footer)
│   ├── app_server.R            # language state + module servers
│   ├── app_data.R             # TEMPLATES (fields tables) + i18n strings (L)
│   ├── fct_translate.R         # header-matching + workbook read/translate helpers
│   ├── mod_home.R              # Home tab (bs4Dash boxes + links to edit)
│   ├── mod_template_tab.R      # shared tab module (UI + server)
│   ├── mod_sample.R            # one module per template tab (thin wrappers)
│   ├── mod_experimental.R
│   ├── mod_ontology.R
│   └── mod_germplasm.R
└── inst/
    ├── golem-config.yml
    ├── app/www/
    │   ├── custom.css          # DeltaBreed palette (Familia-style :root naming)
    │   └── logos2.png
    └── extdata/templates/      # blank English + *_ES.xls templates served for download
```

### Layout & modules

The shell is a `bs4Dash::bs4DashPage` (navbar with the logo + language toggle, a
light sidebar menu, `tabItems` body, and a footer) — the same layout style as
Familia. The sidebar has **Home** plus one entry per template.

Every tab is a module. `mod_home` is the welcome page (bs4Dash boxes with a
localized intro and a **Links** box whose `href`s are placeholders to edit). The
four template tabs share the same structure and differ only by configuration, so
`mod_sample`, `mod_experimental`, `mod_ontology` and `mod_germplasm` are thin
wrappers around a shared `template_tab_ui()` / `template_tab_server()` in
`mod_template_tab.R`, each passed its entry from `TEMPLATES`. The app-level
**English / Español** toggle is a single `reactive` passed into every module server.

Each template tab provides: a **Blank template** section (English original + Spanish
`.xls`), a collapsible **Translation Guide**, and a **Converter** (upload a filled
template, pick a direction, download it with headers swapped).

### Styling (same mechanism as Familia)

`golem_add_external_resources()` registers the `www/` path with
`add_resource_path("www", app_sys("app/www"))` and pulls everything in
`inst/app/www` — including `custom.css` — via `golem::bundle_resources()`. The logo
is referenced as `www/logos2.png`. `custom.css` styles the bs4Dash sidebar (active
item purple), navbar toggle, Home boxes (`.card-*` status colors) and the converter
components.

`custom.css` follows the **DeltaBreed Style Guide v1.2** and defines colors in the
same `--<hue>-core / -lite / -deep` `:root` convention as Familia's `custom.css`
(`--purple-core: #753FCD`, `--purple-deep: #602DAE`, `--teal-core: #3FB3B6`,
`--red-core: #DF1659`, `--green-core: #1C7B36`, `--grey-core: #808080`,
`--font-core: #363636`). Change a value there and it updates everywhere.

## Blank Spanish templates

`inst/extdata/templates/*_ES.xls` are currently interim (only the Data-sheet
headers are translated). To ship a fully translated template, drop a `.xls` with the
same `<base>_ES.xls` filename into that folder — it is served automatically, no code
change needed.
