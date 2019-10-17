#' List all source path
#'
#' This is a helper funciton that can list all source path on screen.
#' The output has three part, first part is status, if files or directories are not exist,
#' it would show a smile or bad face. The second part is source name, and last part is the source path.
#'
#' @return Source imformation.
#'
#' @examples
#'
#' tt_ls()
#'
#' @export
tt_ls <- function() {
  tmp_df <- tt_source_path
  cwidth <- max(stringr::str_length(names(tmp_df)))
  df_nm <- stringr::str_pad(names(tmp_df), width = cwidth, side = "right", pad = " ")
  df_con <- unname(unlist(tmp_df))
  cat(sprintf("%s %s  ==>  \"%s\"",check_path(df_con), df_nm, df_con), sep = "\n")
}

check_path <- function(.path, mark = TRUE) {
  results <- dir.exists(.path) | file.exists(.path)
  if (mark) {
    results <- dplyr::if_else(results, crayon::green(":)"), crayon::red(":("))
  }
  results
}



