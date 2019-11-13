#' Get all source path
#'
#' You can use `tt_ls()` to see all source and name.
#'
#' @param path_name the name of source
#'
#' @return the source's path
#' @export
#'
#' @examples
#'
#' tt_get_path("PATH_AREA")
#'
#' tt_get_path("PATH_FULL_HSCODE")
#'
tt_get_path <- function(path_name) {
  ind <- which(names(.tt_source_path) == path_name)

  if (identical(ind, integer(0))) {
    stop("Incorrect path name\n", call. = FALSE)
  }

  unname(unlist(.tt_source_path[ind]))
}
