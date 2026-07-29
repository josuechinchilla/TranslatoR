# ============================================================================
# Utility / helper functions (pure, no Shiny reactivity).
# Header matching + workbook read/translate helpers used by the tab modules.
# ============================================================================

#' Normalize a header for matching
#'
#' Lowercase, strip accents, drop punctuation and collapse whitespace so that
#' e.g. "N.° de Repetición" and "Exp Replicate #" match regardless of accents,
#' case or stray spaces.
#'
#' @param x Character vector of header values.
#' @return Normalized character vector.
#' @noRd
normalize_hdr <- function(x) {
  x <- as.character(x); x[is.na(x)] <- ""
  x <- tolower(trimws(x))
  x <- iconv(x, to = "ASCII//TRANSLIT"); x[is.na(x)] <- ""
  x <- gsub("[^a-z0-9]+", " ", x)
  x <- trimws(gsub("[[:space:]]+", " ", x))
  x
}

#' Build a normalized lookup dictionary for a template + direction
#'
#' @param fields A template's fields data.frame (en, es, ...).
#' @param direction "es2en" or "en2es".
#' @return Named list mapping normalized header -> target header.
#' @noRd
build_dict <- function(fields, direction) {
  d <- list()
  for (i in seq_len(nrow(fields))) {
    en <- fields$en[i]; es <- fields$es[i]
    if (direction == "es2en") {
      d[[normalize_hdr(es)]] <- en   # Spanish -> English
      d[[normalize_hdr(en)]] <- en   # English passes through unchanged
    } else {
      d[[normalize_hdr(en)]] <- es   # English -> Spanish
      d[[normalize_hdr(es)]] <- es   # Spanish passes through unchanged
    }
  }
  d
}

#' Map a vector of headers through a dictionary
#'
#' @param headers Character vector of header values.
#' @param dict Dictionary from build_dict.
#' @return list(new = character, matched = logical).
#' @noRd
map_headers <- function(headers, dict) {
  new <- character(length(headers)); matched <- logical(length(headers))
  for (i in seq_along(headers)) {
    k <- normalize_hdr(headers[i])
    if (nzchar(k) && !is.null(dict[[k]])) { new[i] <- dict[[k]]; matched[i] <- TRUE }
    else { new[i] <- as.character(headers[i]); matched[i] <- FALSE }
  }
  list(new = new, matched = matched)
}

#' Read a workbook / CSV into a list of sheets
#'
#' Each sheet is a character data.frame read with no header, so row 1 holds the
#' header values verbatim.
#'
#' @param path File path (with a proper .xls/.xlsx/.csv extension).
#' @param fname Original file name (for labelling).
#' @return list(type, sheets, sns, fname).
#' @noRd
read_workbook <- function(path, fname) {
  ext <- tolower(tools::file_ext(path))
  if (ext %in% c("xls", "xlsx")) {
    sns <- readxl::excel_sheets(path)
    sheets <- lapply(sns, function(s) {
      df <- tryCatch(
        as.data.frame(readxl::read_excel(path, sheet = s, col_names = FALSE, col_types = "text")),
        error = function(e) data.frame(X = character(0), stringsAsFactors = FALSE))
      df[] <- lapply(df, as.character); df
    })
    names(sheets) <- sns
    list(type = "excel", sheets = sheets, sns = sns, fname = fname)
  } else if (ext == "csv") {
    m <- tryCatch(
      utils::read.csv(path, header = FALSE, colClasses = "character",
               check.names = FALSE, stringsAsFactors = FALSE,
               na.strings = character(0), fileEncoding = "UTF-8"),
      error = function(e) utils::read.csv(path, header = FALSE, colClasses = "character",
                                   check.names = FALSE, stringsAsFactors = FALSE, na.strings = character(0)))
    m[] <- lapply(m, as.character)
    list(type = "csv", sheets = list(Data = m), sns = "Data", fname = fname)
  } else {
    list(type = "error", fname = fname)
  }
}

#' Parse an uploaded file (fileInput value) into sheets
#'
#' @param f A fileInput value (list with `name` and `datapath`).
#' @return See read_workbook.
#' @noRd
parse_upload <- function(f) {
  ext <- tolower(tools::file_ext(f$name))
  path <- paste0(f$datapath, ".", ext)
  file.copy(f$datapath, path, overwrite = TRUE)
  read_workbook(path, f$name)
}

#' Identify the Data sheet
#'
#' Prefer a sheet literally named "Data"; otherwise the sheet whose header row
#' overlaps most with the template's known headers.
#'
#' @param parsed A parsed workbook from read_workbook.
#' @param fields A template's fields data.frame.
#' @return Sheet name.
#' @noRd
find_data_sheet <- function(parsed, fields) {
  if (parsed$type != "excel") return("Data")
  idx <- which(tolower(parsed$sns) == "data")
  if (length(idx) >= 1) return(parsed$sns[idx[1]])
  known <- unique(c(normalize_hdr(fields$en), normalize_hdr(fields$es)))
  best <- parsed$sns[1]; bestn <- -1
  for (s in parsed$sns) {
    hdr <- as.character(unlist(parsed$sheets[[s]][1, ]))
    n <- sum(normalize_hdr(hdr) %in% known)
    if (n > bestn) { bestn <- n; best <- s }
  }
  best
}

#' Translate only the Data-sheet header row (row 1) in a given direction
#'
#' @param cur A parsed workbook from read_workbook.
#' @param fields A template's fields data.frame.
#' @param direction "es2en" or "en2es".
#' @return The list of sheets with the Data header row translated.
#' @noRd
translate_sheets <- function(cur, fields, direction) {
  dict <- build_dict(fields, direction)
  dsheet <- find_data_sheet(cur, fields)
  sheets <- cur$sheets
  if (!is.null(sheets[[dsheet]]) && nrow(sheets[[dsheet]]) >= 1) {
    hdr <- as.character(unlist(sheets[[dsheet]][1, ]))
    sheets[[dsheet]][1, ] <- map_headers(hdr, dict)$new
  }
  sheets
}
