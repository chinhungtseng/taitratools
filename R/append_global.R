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

  country_list <- unique(data$country)
  contain_word <- any(grepl(
    str2regex(c("\u5168\u7403", "world", "World"), start = "^", end = "$"),
    country_list
  ))

  if (contain_word) {
    stop("Data contains `World` already!, Please check your data.", call. = FALSE)
  }

  data %>%
    dplyr::group_by(!!!group_vars) %>%
    dplyr::summarise(value = sum(value)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(country = "\u5168\u7403") %>%
    dplyr::select(col_names) %>%
    dplyr::bind_rows(data)
}
