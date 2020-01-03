#' grouped sum
#'
#' @param data data frame
#' @param ... grouped columns
#' @param by summarise by value or count or weight
#'
#' @return data frame
#' @export
tt_grouped_sum <- function(data, ..., by = "value") {
  by <- match.arg(by, c("value", "count", "weight"))
  group_var <- rlang::enquos(...)

  data %>%
    dplyr::group_by(!!! group_var) %>%
    dplyr::summarise(!! rlang::quo_name(by) := sum(!! rlang::sym(by))) %>%
    dplyr::ungroup()
}

