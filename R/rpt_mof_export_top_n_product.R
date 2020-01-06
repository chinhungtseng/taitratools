#' rpt_mof_export_top_n_product
#'
#' @param start_date start_date
#' @param end_date end_date
#' @param period period
#' @param sub_hs_digits hscode digits
#' @param n top n
#' @param country_list country list
#' @param money usd or twd
#' @param industry_type `all_industry` or `industry21` or `version1` or `version2`
#' @param verbose verbose
#'
#' @return list
#' @export
rpt_mof_export_top_n_product <- function(start_date, end_date, period = 3, sub_hs_digits = 11, n = 3,
  country_list = NULL, money = "usd", industry_type = "all_industry", verbose = TRUE) {

  date_info <- tt_parse_date(start_date, end_date, period)
  if (money == "usd") {
    currency <- "\u5343\u7f8e\u5143"
  } else {
    currency <- "\u5343\u81fa\u5e63"
  }
  mof_rawdata <- tt_vroom_mof(start_date, end_date, period = period, money = money, dep_month_cols = TRUE)
  tmp_data <- mof_rawdata %>%
    tt_df_sub_hscode(end = sub_hs_digits) %>%
    tt_append_area() %>%
    tt_bind_industry(sub = sub_hs_digits, industry_type = industry_type, verbose = verbose) %>%
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

  if (!is.null(country_list)) {
    tmp_data_by_id_info <- tmp_data_by_id_info %>% dplyr::filter(country %in% country_list)
  }

  list(
    date = paste0(start_date, " - ", end_date),
    data = tmp_data_by_id_info
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
