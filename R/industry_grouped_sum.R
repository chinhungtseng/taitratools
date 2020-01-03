#' tt_industry_grouped_sum
#'
#' @param x data.frame
#' @param industry_type "all_industry", "industry21", "version1", "version2"
#' @param sub sub hscode
#' @param verbose TRUE or FALSE
#'
#' @return a list
#' @export
tt_industry_grouped_sum <- function(x, industry_type = "all_industry", sub = 11, verbose = TRUE) {
  stopifnot(check_industry_type(industry_type))
  tmp_data <- tt_grouped_sum(x, hscode, country, year)
  tmp_data <- tt_bind_industry(tmp_data, sub = sub, col_more = TRUE, industry_type = industry_type, verbose = verbose)
  tmp_data <- tt_grouped_sum(tmp_data, type, major, minor, industry, country, year)
  list(
    industry_type = industry_type,
    data = tmp_data
  )
}
