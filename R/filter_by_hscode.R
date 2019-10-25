#' Filter data by specific hscode
#'
#' @param .df A data frame
#' @param hscode A string or character vector
#' @param new_col Create new column name
#' @param sub hscode digits
#'
#' @return data frame
#'
#' @export
tt_filter_by_hscode <- function(.df, hscode, new_col = NULL, sub = 10) {
  stopifnot(is.character(hscode))
  stopifnot("hscode" %in% names(.df))
  stopifnot(length(new_col) == 1 | is.null(new_col))
  stopifnot(is.character(new_col) | is.null(new_col))

  if (length(hscode) > 1) {
    hscode <- paste0(hscode, collapse = ",")
  }

  output_pattern <- str2regex(hscode, sub = sub)
  tmp_output <- .df[stringr::str_detect(.df$hscode, output_pattern), ]

  if (!is.null(new_col)) {
    tmp_output$industry <- new_col
  }
  tmp_output
}
