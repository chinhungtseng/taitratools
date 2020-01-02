
rpt_mof_export_summary_by_each_country_and_industry <- function(start_date, end_date, period = 3, country_list = NULL, money = "usd", destdir = ".") {
  stopifnot(validate_tt_read_mof(start_date, end_date, period, "export", money))
  stopifnot(dir.exists(destdir))

  date_info <- tt_parse_date(start_date, end_date, period)
  mof_rawdata <- tt_vroom_mof(start_date, end_date, period = period, money = money, dep_month_cols = TRUE)

  mof_data_with_ind <- mof_rawdata %>%
    tt_grouped_sum(hscode, country, year) %>%
    tt_bind_industry(col_more = TRUE, reports = "version2") %>%
    tt_grouped_sum(type, major, minor, industry, country, year)

  mof_data_calculated <- mof_data_with_ind %>%
    tt_append_area() %>%
    tt_spread_value(by = "year") %>%
    dplyr::mutate(
      growth_rate = cal_growth_rate(!! rlang::sym(date_info$start_year), !! rlang::sym(date_info$last_year)),
      cagr = cal_cagr(!! rlang::sym(date_info$start_year), !! rlang::sym(date_info$end_year), period = period)
    ) %>%
    dplyr::arrange(country) %>%
    tidyr::gather("year", "value", date_info$years) %>%
    dplyr::filter(year == date_info$start_year)

  if (!is.null(country_list)) {
    mof_data_calculated <- mof_data_calculated %>% dplyr::filter(country %in% country_list)
  }

  if (money == "usd")
    currency <- "\u5343\u7f8e\u5143"
  else
    currency <- "\u5343\u81fa\u5e63"

  chinese_column_names <- c(
    "\u570b\u5bb6", "\u7522\u696d",
    paste0(date_info$start_year, "\u5e74", date_info$start_month, "-", date_info$end_month, "\u6708\u51fa\u53e3\u984d(", currency, ")"),
    paste0(date_info$start_year, "\u5e74", date_info$start_month, "-", date_info$end_month, "\u6708\u51fa\u53e3\u6210\u9577\u7387(%)"),
    paste0(date_info$start_year, "\u5e74", date_info$start_month, "-", date_info$end_month, "\u6708", period, "\u5e74\u51fa\u53e3\u8907\u5408\u6210\u9577\u7387(%)"),
    "\u4f54\u6bd4(%)"
  )

  output_file_name <- paste0(
    date_info$start_year, "\u5e74",
    date_info$start_month, "-", date_info$end_month, "\u6708",
    "\u81fa\u7063\u5c0d\u5404\u570b\u51fa\u53e3\u60c5\u52e2_", format(Sys.Date(), "%Y%m%d"), ".xlsx"
  )

  outputs <- mof_data_calculated %>%
    split(.$country) %>%
    purrr::map(~ .x %>%
        dplyr::mutate(share = cal_share(value, .[.$industry == "\u5168\u90e8\u7522\u54c1_\u5168\u90e8\u7522\u54c1", ][["value"]])) %>%
        tt_order_by_industry_for_reports(version = "version2") %>%
        dplyr::mutate(industry = tt_convert_industry_name(major, minor)) %>%
        dplyr::select(country, industry, value, growth_rate, cagr, share) %>%
        rlang::set_names(chinese_column_names)
    )

  if (!is.null(destdir)) {
    if (!is.null(country_list)) {
      purrr::iwalk(outputs, ~ xlsx::write.xlsx(as.data.frame(.x), file.path(destdir, output_file_name),
        sheetName = .y, row.names = FALSE, append = TRUE, showNA = FALSE))
    } else {
      xlsx::write.xlsx(as.data.frame(reduce(outputs, bind_rows)),
        file.path(destdir, output_file_name), row.names = FALSE, append = FALSE, showNA = FALSE)
    }

    list(
      filename = output_file_name,
      data = purrr::reduce(outputs, bind_rows)
    )
  } else {
    list(
      filename = "no output",
      data = purrr::reduce(outputs, bind_rows)
    )
  }
}
