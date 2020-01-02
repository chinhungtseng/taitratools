#' spread data by specified column
#'
#' @param x a data.frame
#' @param by a character
#' @param na2zero replace value with zero or not.
#'
#' @return data.frame
#' @export
tt_spread_value <- function(x, by, na2zero = TRUE) {
  col_nm <- names(x)
  stopifnot(all(c(by, "value") %in% col_nm))

  new_cols <- unique(x[[by]])
  tmp <- tidyr::spread(x, !! sym(by), value)
  if (na2zero) {
    tmp <- dplyr::mutate_at(tmp,
      dplyr::vars(new_cols), list(~ tidyr::replace_na(., 0))
    )
  }
  tmp
}
