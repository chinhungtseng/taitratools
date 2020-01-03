#' append global value
#'
#' @param data data frame
#'
#' @return data frame
#' @export
tt_append_global <- function(data) {
  key_vars <- c("country", "value")
  col_names <- names(data)
  stopifnot(key_vars %in% col_names)

  group_vars <- rlang::syms(col_names[!(col_names %in% key_vars)])
  if (check_contain_global(data)) {
    stop("Data contains `World` already!, Please check your data.", call. = FALSE)
  }

  data %>%
    tt_grouped_sum(!!!group_vars) %>%
    dplyr::mutate(country = "\u5168\u7403") %>%
    dplyr::select(col_names) %>%
    dplyr::bind_rows(data)
}

#' append area value
#'
#' @param data data frame
#'
#' @return data frame
#' @export
tt_append_area <- function(data) {
  key_vars <- c("country", "value")
  col_names <- names(data)
  stopifnot(key_vars %in% col_names)

  group_vars <- rlang::syms(col_names[col_names != "value"])
  if (check_contain_global(data)) {
    stop("Data contains `World` already!, Please check your data.", call. = FALSE)
  }

  data %>%
    tt_bind_area() %>%
    dplyr::mutate(country = area) %>%
    tt_grouped_sum(!!!group_vars) %>%
    dplyr::select(col_names) %>%
    dplyr::bind_rows(data)
}


check_contain_global <- function(x) {
  stopifnot("country" %in% names(x))
  country_list <- unique(x$country)
  contain_word <- any(grepl(
    str2regex(c("\u5168\u7403", "world", "World"), start = "^", end = "$"),
    country_list
  ))
  contain_word
}
