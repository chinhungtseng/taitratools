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

  data %>%
    dplyr::group_by(!!!group_vars) %>%
    dplyr::summarise(value = sum(value)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(country = "\u5168\u7403") %>%
    dplyr::select(col_names) %>%
    dplyr::bind_rows(data)
}
