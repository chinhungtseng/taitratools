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

#' Show hscode chinese name
#'
#' @param hscode hscode
#' @param chinese chinese
#'
#' @return data frame
#' @export
tt_hscode_show <- function(hscode = NULL, chinese = NULL) {
  stopifnot(
    !is.null(hscode) & is.null(chinese) |
    is.null(hscode) & !is.null(chinese)
  )
  stopifnot(length(hscode) == 1)

  if (is.null(chinese)) {
    hscode <- as.character(hscode)
    if (nchar(hscode) %% 2 != 0)
      hscode <- substr(hscode, 1, (nchar(hscode) - 1))

    output <- list(hscode)
    while (nchar(hscode) > 2) {
      hscode <- substr(hscode, 1, nchar(hscode) - 2)
      output <- append(list(hscode), output)
    }

    patterns <- str2regex(unlist(output), end = "$")
    .full_hscode_tbl[stringr::str_detect(.full_hscode_tbl$hscode, patterns), ]
  } else {
    patterns <- str2regex(unlist(chinese), start = "", end = "")
    .full_hscode_tbl[stringr::str_detect(.full_hscode_tbl$hscode_cn, patterns), ]
  }
}
