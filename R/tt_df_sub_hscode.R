#' tt_df_sub_hscode
#'
#' @param x data
#' @param start integer
#' @param end integer
#' @param by "value" or "count" or "weight"
#' @param forct_year drop month
#'
#' @return data.frame
#' @export
tt_df_sub_hscode <- function(x, start = 1L, end = -1L, by = "value", forct_year = TRUE) {
  col_nm <- names(x)
  stopifnot(contain_all_keywords(col_nm, "hscode", "country", "year") |
            contain_all_keywords(col_nm, "hscode", "country", "year", "month"))

  tmp_data <- dplyr::mutate(x, hscode = stringr::str_sub(hscode, start, end))
  if (contain_all_keywords(names(tmp_data), "month") & !forct_year) {

    tmp_data <- tt_grouped_sum(tmp_data, hscode, country, year, month, by = by)
  } else {

    tmp_data <- tt_grouped_sum(tmp_data, hscode, country, year, by = by)
  }

  tmp_data
}
