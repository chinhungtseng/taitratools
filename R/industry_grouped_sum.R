#' tt_industry_grouped_sum
#'
#' @param x data.frame
#' @param industryType "all_industry", "industry21", "version1", "version2"
#'
#' @return a list
#' @export
tt_industry_grouped_sum <- function(x, industryType = "all_industry") {
  stopifnot(check_industry_type(industryType))
  tmp_data <- tt_grouped_sum(x, hscode, country, year)
  switch (industryType,
    all_industry = {
      tmp_data <- tt_bind_industry(tmp_data, col_more = TRUE)
    },
    industry21 = {
      tmp_data <- tt_bind_industry(tmp_data, col_more = TRUE, ind21 = TRUE)
    },
    version1 = {
      tmp_data <- tt_bind_industry(tmp_data, col_more = TRUE, reports = "version1")
    },
    version2 = {
      tmp_data <- tt_bind_industry(tmp_data, col_more = TRUE, reports = "version2")
    }
  )
  tmp_data <- tt_grouped_sum(tmp_data, type, major, minor, industry, country, year)
  list(
    industry_type = industryType,
    data = tmp_data
  )
}
