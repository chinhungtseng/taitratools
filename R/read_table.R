#' Easily read files.
#'
#' This function is based on readr, readxls, and feather packages.
#' You can easily read a file just with one function.
#' Support file format: `.csv`, `.tsv`, `.xlsx`, `.xls`, `.feather`, `.rds`.
#'
#' @param path string
#' @param col_types column type
#' @param sheet integer
#'
#' @return data.frame
#' @export
#'
tt_read_table <- function(path, col_types = NULL, sheet = NULL) {
  if (!file.exists(path) & !stringr::str_detect(path, "^https?://")) stop(sprintf("'%s' does not exist.", path), call. = FALSE)
  if (is.null(sheet)) sheet = 1

  if (is.null(col_types)) col_types <- readr::cols()

  file_format <- stringr::str_extract(path, "\\.(xlsx|XLSX|tsv|TSV|csv|CSV|feather|FEATHER|xls|XLS|rds|RDS)$")
  file_format <- tolower(file_format)

  switch(file_format,
    ".csv" = {readr::read_csv(file = path, col_types = col_types)},
    ".tsv" = {readr::read_tsv(file = path, col_types = col_types)},
    ".xlsx" = {readxl::read_xlsx(path, sheet = sheet)},
    ".xls" = {readxl::read_xls(path, sheet = sheet)},
    ".feather" = {feather::read_feather(path)},
    ".rds" = {readr::read_rds(path)},
    stop("File format not support!", call. = FALSE)
  )
}
