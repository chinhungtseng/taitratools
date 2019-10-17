#' Easily read files.
#'
#' This function is based on readr, readxls, and feather packages.
#' You can easily read a file just with one function.
#' Support file format: `.csv`, `.tsv`, `.xlsx`, `.xls`, `.feather`.
#'
#' @param path string
#' @param sheet integer
#'
#' @return data.frame
#' @export
#'
tt_read_table <- function(path, sheet = NULL) {
  if (!file.exists(path) & !stringr::str_detect(path, "^https?://")) stop(sprintf("'%s' does not exist.", path), call. = FALSE)
  if (is.null(sheet)) sheet = 1

  file_format <- stringr::str_extract(path, "\\.(xlsx|XLSX|tsv|TSV|csv|CSV|feather|FEATHER|xls|XLS)$")
  file_format <- tolower(file_format)

  if (is.na(file_format)) {
    stop("File format not support!", call. = FALSE)

  } else if (file_format == ".csv") {
    return(readr::read_csv(file = path, col_types = readr::cols()))

  } else if (file_format == ".tsv") {
    return(readr::read_tsv(file = path, col_types = readr::cols()))

  } else if (file_format == ".xlsx") {
    return(readxl::read_xlsx(path, sheet = sheet))

  } else if (file_format == ".xls") {
    return(readxl::read_xls(path, sheet = sheet))

  } else if (file_format == ".feather") {
    return(feather::read_feather(path))

  }
}
