#' tt_ext_world_value
#'
#' @description input data, output data only world value
#'
#' @param x data.frame
#' @param column_nm column name
#' @param by_country by country or not
#'
#' @return numeric value
#' @export
tt_ext_world_value <- function(x, column_nm = NULL, by_country = FALSE) {
  col_names <- names(x)
  stopifnot(
    contain_all_keywords(col_names, "type", "major", "minor", "value") |
      contain_all_keywords(col_names, "industry", "value")
  )
  # if data have `country` column, keep only world's values
  if (contain_all_keywords(col_names, "country") & !by_country) {
    x <- x[grepl("^(\u5168\u7403|\u4e16\u754c|[Ww]orld)$", x$country), ]
  }
  if (is.null(column_nm)) {
    if (contain_all_keywords("industry", "value")) {
      world_value <- x[x$industry == "\u5168\u90e8\u7522\u54c1_\u5168\u90e8\u7522\u54c1", ][["value"]]
    } else {
      world_value <- x[x$type  == "\u5168\u90e8\u7522\u54c1" &
          x$major == "\u5168\u90e8\u7522\u54c1" &
          x$minor == "\u5168\u90e8\u7522\u54c1", ][["value"]]
    }
  } else {
    world_value <- x[x[[column_nm]] == "\u5168\u90e8\u7522\u54c1_\u5168\u90e8\u7522\u54c1", ][["value"]]
  }
  stopifnot(length(world_value) == 1)
  world_value
}
