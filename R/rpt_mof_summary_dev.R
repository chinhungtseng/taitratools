#' rpt_mof_summary_dev
#'
#' @param start_date .
#' @param end_date .
#' @param period .
#' @param sub_hs_digits .
#' @param n .
#' @param country_list .
#' @param direct .
#' @param money .
#' @param industry_type .
#' @param destdir .
#' @param verbose .
#'
#' @return list
#' @export
rpt_mof_summary_dev <- function(start_date, end_date, period = 3, sub_hs_digits = 11, n = 3,
  country_list = NULL, direct = "export", money = "usd", industry_type = "all_industry", destdir = ".", verbose = TRUE) {

  stopifnot(validate_tt_read_mof(start_date, end_date, period))
  if (!is.null(destdir)) {stopifnot(dir.exists(destdir))}
  stopifnot(check_industry_type(industry_type))

  if (money == "usd") {
    currency <- "\u5343\u7f8e\u5143"
  } else {
    currency <- "\u5343\u81fa\u5e63"
  }

  if (direct == "export") {
    port <- "\u51fa\u53e3\u984d"
  } else {
    port <- "\u9032\u53e3\u984d"
  }

  date_info <- tt_parse_date(start_date, end_date, period)
  mof_rawdata <- tt_vroom_mof(start_date, end_date, period = period, direct = direct, money = money, dep_month_cols = TRUE)

  mof_rawdata <- mof_rawdata %>%
    tt_df_sub_hscode(end = sub_hs_digits) %>%
    tt_bind_industry(sub = sub_hs_digits, industry_type = industry_type, verbose = verbose, col_more = TRUE)

  # part 1 --------------------------------------------
  tmp_data <- mof_rawdata %>%
    tt_append_area() %>%
    tt_spread_value(by = "year") %>%
    dplyr::mutate(id = paste0(country, "-", industry))

  tmp_data_by_id <- split(tmp_data, tmp_data$id)

  tmp_data_by_id_info <- tmp_data_by_id %>%
    purrr::map(~ {
      .x %>%
        dplyr::filter(!!rlang::sym(date_info$start_year) != 0 & !!rlang::sym(date_info$last_year) != 0 ) %>%
        dplyr::mutate(
          difference = !!rlang::sym(date_info$start_year) - !!rlang::sym(date_info$last_year),
          growth_rate = cal_growth_rate(!!rlang::sym(date_info$start_year), !!rlang::sym(date_info$last_year)),
          share = cal_share(!!rlang::sym(date_info$start_year), sum(.[[date_info$start_year]])),
          rank = rank(dplyr::desc(difference))
        ) %>%
        dplyr::arrange(dplyr::desc(difference)) %>%
        tt_df_filter_top_and_bottom_n(n, difference) %>%
        dplyr::mutate(sub_info = get_pn_label(difference, n = n))
    }) %>%
    purrr::reduce(dplyr::bind_rows) %>%
    tt_df_mutate_chinese_hscode() %>%
    dplyr::mutate(info = paste0(
      hscode, ",", hscode_ch, ",",
      "\u51fa\u53e3\u984d:", !!rlang::sym(date_info$start_year), currency, ",",
      "\u6210\u9577\u7387:", growth_rate, "%", ",",
      "\u4f54\u6bd4:", share, "%", ",",
      "\u5dee\u7570:", difference, currency
    )) %>%
    dplyr::select(id, info, sub_info) %>%
    dplyr::filter(!is.na(sub_info)) %>%
    tidyr::complete(id, sub_info) %>%
    tidyr::spread(sub_info, info) %>%
    tidyr::separate(id, into = c("country", "industry"), sep = "-") %>%
    dplyr::select(country, industry, dplyr::contains("\u589e\u984d"), dplyr::contains("\u6e1b\u984d"))

  # part 2 --------------------------------------------
  mof_data_with_ind <- mof_rawdata %>%
    dplyr::group_by(type, major, minor, industry, country, year) %>%
    dplyr::summarise(value = sum(value)) %>% dplyr::ungroup()

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

  mof_data_calculated <- dplyr::left_join(
    mof_data_calculated, tmp_data_by_id_info,
    by = c("country", "industry")
  )

  if (!is.null(country_list)) {
    mof_data_calculated <- mof_data_calculated %>% dplyr::filter(country %in% country_list)
  }

  col_label <- paste0(date_info$start_year, "\u5e74", date_info$start_month, "-", date_info$end_month, "\u6708")
  chinese_column_names <- c(
    "\u570b\u5bb6", "\u7522\u696d",
    paste0(col_label, port, "(", currency, ")"),
    paste0(col_label, "\u589e\u6e1b\u984d(", currency, ")"),
    paste0(col_label, "\u51fa\u53e3\u6210\u9577\u7387(%)"),
    paste0(col_label, period, "\u5e74\u51fa\u53e3\u8907\u5408\u6210\u9577\u7387(%)"),
    "\u4f54\u6bd4(%)", names(tmp_data_by_id_info)[c(-1, -2)]
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
        dplyr::select(country, industry, value, difference, growth_rate,
          cagr, share, dplyr::contains("\u589e\u984d"), dplyr::contains("\u6e1b\u984d")) %>%
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
    filename      = output_file_name,
    date          = paste0(start_date, " - ", end_date),
    port          = direct,
    currency      = money,
    hscode_digits = sub_hs_digits,
    period        = period,
    industry_type = industry_type,
    data          = outputs
  )
}

get_pn_label <- function(x, n) {
  output <- rep(NA_character_, length(x))
  x <- is_positive(x)
  nlen <- length(x) - (plen <- sum(x))
  # positive
  if (plen != 0) {
    if (plen >= n) {
      output[seq_len(n)] <- paste0("\u589e\u984d", seq_len(n))
    } else if (plen < n) {
      output[seq_along(plen)] <- paste0("\u589e\u984d", seq_len(plen))
    }
  }
  # negative
  if (nlen != 0) {
    if (nlen >= n) {
      output[length(output):(length(output) - n + 1)] <- paste0("\u6e1b\u984d", seq_len(n))
    } else if (nlen < n) {
      output[length(output):(length(output) - nlen + 1)] <- paste0("\u6e1b\u984d", seq_len(nlen))
    }
  }
  output
}
