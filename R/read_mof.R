#' Read Data from MOF SOURCE
#'
#' Reading mof data with `start date` and `end date`. If you want to read data with many year you can specify the `period`.
#'
#' @param start_date Start date with "year-month" format. ex> "2019-01".
#' @param end_date End date with "year-month" format. ex> "2019-01".
#' @param period Integer.
#' @param direct A string used to specify `export` and `import` values. The default value is `export`.
#' @param money A string used to specify `usd` and `twd` value. The default value is `usd`.
#' @param columns a character vector.
#' @param dep_month_cols create year and month column, default is only year column with "\%Y-\%m" format.
#' @param fixed_cny_nm boolean: fixed country names. if you want to combine mof and 05_all_data you need to set fixed_cny_cols = TRUE
#' @param suppress suppress read message
#' @param source_path source path.
#'
#' @return data.frame
#' @export
tt_read_mof <- function(start_date, end_date, period = 0, direct = "export", money = "usd", columns = NULL, dep_month_cols = FALSE, fixed_cny_nm = FALSE, suppress = FALSE, source_path = "SOURCE_MOF"){
  stopifnot(validate_tt_read_mof(start_date, end_date, period, direct, money))

  period_list <- period_month(ym2date(start_date), ym2date(end_date), "%Y-%m")

  if (period > 0) {
    tmp_period_list <- NULL
    for (i in 1:period) {
      tmp_period_list <- c(tmp_period_list, get_past_year(period_list, period = i))
    }
    period_list <- c(period_list, tmp_period_list)
  }

  file_path <- sprintf("%s/mof-%s-%s/%s.tsv", tt_get_path(source_path), direct, money, period_list)

  tmp_df <- vector("list", length(file_path))
  for (i in seq_along(file_path)) {

    if (!suppress) print_with_time(file_path[i])

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

  if (fixed_cny_nm) {
    tmp_df <- fixed_country_names(tmp_df)
  }

  if (dep_month_cols) {
    tmp_df <- tidyr::separate(tmp_df, year, into = c("year", "month"))
  }

  tmp_df
}

validate_tt_read_mof <- function(start_date, end_date, period, direct, money) {
  if (ym2date(end_date) >= ym2date(format(Sys.Date(), "%Y-%m"))) {
    stop(paste0("No `", end_date, "` data!"), call. = FALSE)
  }

  if (ym2date(start_date) > ym2date(end_date)) {
    stop(paste0("Start date: `", start_date, "` can not greater then End date: `", end_date, "`"), call. = FALSE)
  }
  stopifnot(validate_date(start_date), validate_date(end_date))
  stopifnot(is.numeric(period))
  stopifnot(direct %in% c("export", "import"))
  stopifnot(money %in% c("usd", "twd"))

  TRUE
}

validate_date <- function(date) {
  stringr::str_detect(date, "^\\d{4}-([0][1-9])|(1[0-2])$")
}

# 2019-11-01 Adding by Peter
# reference:
# //172.20.23.190/ds/01_jack/jack工作內容/02_資料彙整與運算/04_mof.R - Line:57 to line:58.
fixed_country_names <- function(.tmp_df) {
  .country_list <- c(
    "\u53f2\u74e6\u5e1d\u5c3c" = "\u53f2\u74e6\u6fdf\u862d",
    "\u84cb\u4e9e\u90a3" = "\u572d\u4e9e\u90a3",
    "\u99ac\u7d39\u723e\u7fa4\u5cf6\u5171\u548c\u570b" = "\u99ac\u7d39\u723e\u7fa4\u5cf6",
    "\u8499\u7279\u5167\u54e5\u7f85\u5171\u548c\u570b" = "\u8499\u7279\u5167\u54e5\u7f85",
    "\u8305\u5229\u5854\u5c3c\u4e9e\u4f0a\u65af\u862d\u5171\u548c\u570b" = "\u8305\u5229\u5854\u5c3c\u4e9e",
    "\u570b\u5bb6" = "\u5730\u5340"
  )

  for (i in seq_along(.country_list)) {
    .tmp_df$country <- gsub(
      names(.country_list[i]),
      unname(.country_list[i]),
      .tmp_df$country
    )
  }

  .tmp_df
}

