#' convert column name lower case
#'
#' @param x data frame
#'
#' @return data frame
#' @export
#'
tt_df_lower_name <- function(x) {
  names(x) <- tolower(names(x))
  x
}

#' convert column name upper case
#'
#' @param x data frame
#'
#' @return data frame
#' @export
#'
tt_df_upper_name <- function(x) {
  names(x) <- toupper(names(x))
  x
}
