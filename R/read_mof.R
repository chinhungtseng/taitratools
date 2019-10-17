#' Read Data from MOF SOURCE
#'
#' Reading mof data with `start date` and `end date`. If you want to read data with many year you can specify the `period`.
#'
#' @param start_date Start date with "year-month" format. ex> "2019-01".
#' @param end_date End date with "year-month" format. ex> "2019-01".
#' @param direct A string used to specify `export` and `import` values. The default value is `export`
#' @param money A string used to specify `usd` and `twd` value. The default value is `usd`
#' @param period Integer
#' @param columns a character vector
#'
#' @return data.frame
#' @export
tt_read_mof <- function(start_date, end_date, direct = "export", money = "usd", period = 0, columns = NULL) {
  period_list <- period_month(ym2date(start_date), ym2date(end_date), "%Y-%m")

  if (period > 0) {
    tmp_period_list <- NULL
    for (i in 1:period) {
      tmp_period_list <- c(tmp_period_list, get_past_year(period_list, period = i))
    }
    period_list <- c(period_list, tmp_period_list)
  }

  file_path <- sprintf("%s/mof-%s-%s/%s.tsv", tt_get_path("SOURCE_MOF"), direct, money, period_list)

  tmp_df <- vector("list", length(file_path))
  for (i in seq_along(file_path)) {
    print_with_time(file_path[i])
    single_df <- readr::read_delim(file = file_path[i], delim = '\t', col_types = "ccccncncn", progress = FALSE)
    single_df <- dplyr::distinct(single_df)
    single_df$year <- stringr::str_extract(file_path[i], "\\d{4}-\\d{2}")
    tmp_df[[i]] <- single_df
  }

  tmp_df <- purrr::reduce(tmp_df, dplyr::bind_rows)
  names(tmp_df) <- c("hscode", "hscode_ch", "hscode_en", "country", "count",
                     "count_unit", "weight", "weight_unit", "value", "year")

  tmp_df$hscode <- stringr::str_pad(tmp_df$hscode, width = 11, side = "left", pad = "0")
  if (!is.null(columns)) {
    tmp_df <- tmp_df[, columns]
  }

  tmp_df
}
