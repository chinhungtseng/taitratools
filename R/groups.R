#' grouped sum
#'
#' @param data data frame
#' @param ... grouped columns
#'
#' @return data frame
#' @export
tt_grouped_sum <- function(data, ...) {
  group_var <- rlang::enquos(...)

  data %>%
    dplyr::group_by(!!! group_var) %>%
    dplyr::summarise(value = sum(value)) %>%
    dplyr::ungroup()
}
