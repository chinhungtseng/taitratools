#' order by industry for reports
#' @param df data.frame
#' @param version version 1 or version 2
#'
#' @return data.frame
#' @export
tt_order_by_industry_for_reports <- function(df, version = NULL) {
  stopifnot(!is.null(version))
  if (version == "version1") {
    industry_list <- dplyr::arrange(.tt_ind_verion_1_tbl_en, reports_version_1_order)$industry
  } else if (version == "version2") {
    industry_list <- dplyr::arrange(.tt_ind_verion_2_tbl_en, reports_version_2_order)$industry
  } else {
    stop("Version type not correct!", call. = FALSE)
  }

  stopifnot(all(df$industry %in% industry_list))
  dplyr::arrange(df, purrr::map_dbl(df$industry, ~ which(.x == industry_list)))
}
