#' tt_df_filter_top_and_bottom_n
#'
#' @param x a data.frame to filter
#' @param n number of row to return
#' @param wt variable
#'
#' @return data.frame
#' @export
tt_df_filter_top_and_bottom_n <- function(x, n, wt) {
  wt <- rlang::enquo(wt)
  dplyr::filter(x, dplyr::dense_rank(!!wt) <= n | dplyr::dense_rank(dplyr::desc(!!wt)) <= n)
}
