#' tt_df_mutate_chinese_hscode
#'
#' @param x data.frame
#' @param nm chinese hscode name
#'
#' @return data.frame
#' @export
tt_df_mutate_chinese_hscode <- function(x, nm = "hscode_ch") {
  stopifnot(is.character(nm))
  col_names <- names(x)
  stopifnot(!(nm %in% col_names))
  stopifnot(contain_all_keywords(col_names, "hscode"))
  x[[nm]] <- tt_parse_hscode(x$hscode)
  x
}
