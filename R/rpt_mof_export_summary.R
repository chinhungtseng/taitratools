#' mof export summary by each country and each industry
#'
#' @description
#' calculate mof export summary by each country and each industry
#'
#' @param start_date yyyy-mm
#' @param end_date yyyy-mm
#' @param period the period of cagr year
#' @param sub_hs_digits hscode subset
#' @param country_list filter specified countries
#' @param money usd or twd
#' @param industry_type "all_industry", "industry21", "version1", "version2"
#' @param destdir output directory
#' @param verbose TRUE or FALSE
#'
#' @return a list contains output file name and data
#' @export
rpt_mof_export_summary <- function(start_date, end_date, period = 3, sub_hs_digits = 11,
  country_list = NULL, money = "usd", industry_type = "all_industry", destdir = ".", verbose = TRUE) {

  stopifnot(validate_tt_read_mof(start_date, end_date, period, "export", money))
  if (!is.null(destdir)) {
    stopifnot(dir.exists(destdir))
  }
  stopifnot(check_industry_type(industry_type))

  date_info <- tt_parse_date(start_date, end_date, period)
  mof_rawdata <- tt_vroom_mof(start_date, end_date, period = period, money = money, dep_month_cols = TRUE)
  mof_data_with_ind <- tt_industry_grouped_sum(mof_rawdata, industry_type, sub = sub_hs_digits, verbose = verbose)$data

  mof_data_calculated <- mof_data_with_ind %>%
    tt_append_area() %>%
    tt_spread_value(by = "year") %>%
    dplyr::mutate(
      difference = !! rlang::sym(date_info$start_year) - !! rlang::sym(date_info$last_year),
      growth_rate = cal_growth_rate(!! rlang::sym(date_info$start_year), !! rlang::sym(date_info$last_year)),
      cagr = cal_cagr(!! rlang::sym(date_info$start_year), !! rlang::sym(date_info$end_year), period = period)
    ) %>%
    dplyr::arrange(country) %>%
    tidyr::gather("year", "value", date_info$years) %>%
    dplyr::filter(year == date_info$start_year)

  if (!is.null(country_list)) {
    mof_data_calculated <- mof_data_calculated %>% dplyr::filter(country %in% country_list)
  }

  if (money == "usd") {
    currency <- "\u5343\u7f8e\u5143"
  } else {
    currency <- "\u5343\u81fa\u5e63"
  }

  col_label <- paste0(date_info$start_year, "\u5e74", date_info$start_month, "-", date_info$end_month, "\u6708")
  chinese_column_names <- c(
    "\u570b\u5bb6", "\u7522\u696d",
    paste0(col_label, "\u51fa\u53e3\u984d(", currency, ")"),
    paste0(col_label, "\u589e\u6e1b\u984d(", currency, ")"),
    paste0(col_label, "\u51fa\u53e3\u6210\u9577\u7387(%)"),
    paste0(col_label, period, "\u5e74\u51fa\u53e3\u8907\u5408\u6210\u9577\u7387(%)"),
    "\u4f54\u6bd4(%)"
  )

  outputs <- mof_data_calculated %>%
    split(.$country) %>%
    purrr::map(~ {
      tmp_data <- dplyr::mutate(.x, share = cal_share(value, tt_ext_world_value(.x, by_country = TRUE)))
      if (contain_any_keywords(industry_type, "version1", "version2")) {
        tmp_data <- tt_order_by_industry_for_reports(tmp_data, version = industry_type) %>%
          dplyr::mutate(industry = tt_convert_industry_name(major, minor))
      }
      tmp_data %>%
        dplyr::select(country, industry, value, difference, growth_rate, cagr, share) %>%
        rlang::set_names(chinese_column_names)
    }) %>%
    purrr::reduce(dplyr::bind_rows)

  if (!is.null(destdir)) {
    output_file_name <- paste0(
      date_info$start_year, "\u5e74",
      date_info$start_month, "-", date_info$end_month, "\u6708",
      "\u81fa\u7063\u5c0d\u5404\u570b\u51fa\u53e3\u60c5\u52e2_", format(Sys.Date(), "%Y%m%d"), ".csv"
    )
    readr::write_excel_csv(outputs,
      file.path(destdir, output_file_name), na = "")
  } else {
    output_file_name <- "no output"
  }

  list(
    filename = output_file_name,
    data = outputs
  )
}
