#' Show data frame
#'
#' @param .path taitra source path
#'
#' @return table
#' @export
#'
#' @importFrom utils View
tt_df_show <- function(.path) {
  View(tt_read_table(tt_get_path(.path)))
}
