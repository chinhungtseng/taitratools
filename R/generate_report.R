#' Output report 1
#'
#' @param .start_date start date
#' @param .end_date end date
#' @param .direct import or export
#' @param .money usd or twd
#' @param .industry_keyword industry
#'
#' @return list
#' @export
tt_genReport_1 <- function(.start_date, .end_date, .direct = "export", .money = "usd", .industry_keyword) {
  # data time
  date_label <- paste0(.start_date, " to ", .end_date)
  mof_tbl <- tt_read_mof(.start_date, .end_date, direct = .direct, money = .money, period = 1)

  # filter industry by keyword
  mof_tbl.industry <- tt_bind_industry(mof_tbl, major = .industry_keyword)
  ind_list <- unique(mof_tbl.industry$industry)

  output_tbl <- vector("list", length(ind_list))
  for (i in seq(ind_list)) {
    ind_lable <- ind_list[[i]]
    ind_year <- sort(unique(substr(mof_tbl.industry$year, 1, 4)))
    c_year <- rlang::sym(ind_year[2])
    l_year <- rlang::sym(ind_year[1])

    print_with_time(ind_lable)

    tmp_tbl <- mof_tbl.industry[mof_tbl.industry$industry == ind_list[i], ]
    tmp_mix_tbl <- tt_cal_country_value(tmp_tbl, by = "year")
    tmp_mix_tbl <- dplyr::mutate(
      tmp_mix_tbl,
      difference = !!c_year - !!l_year,
      growth_rate = cal_growth_rate(!!l_year, !!c_year),
      shared = cal_share(!!c_year, tmp_mix_tbl[1, ][[ind_year[2]]])
    )

    tmp_mix_tbl <- dplyr::arrange(tmp_mix_tbl, dplyr::desc(!!c_year))
    tmp_mix_tbl$industry <- ind_lable
    tmp_mix_tbl$period <- date_label

    output_tbl[[i]] <- tmp_mix_tbl
  }

  output_tbl
}


#' Simple calculate sum of every countries by year or month
#'
#' @param .df A data frame. Your date must contain `country`, `year`, and `value` columns!
#' @param by summarise by year or month
#'
#' @return data.frame
#' @export
#' @importFrom stats aggregate
tt_cal_country_value <- function(.df, by = "year") {
  tmp_tbl <- .df
  must_hav <- c("country", "year", "value")

  if (!all(must_hav %in% names(tmp_tbl))) {
    stop("Your data MUST contains `country`, `year`, and `value` columns!", call. = FALSE)
  }

  if (!(by %in% c("year", "month"))) {
    stop(paste0("Invalid argument: '", by, "' ; `by` must `year` or `month`!"), call. = FALSE)
  }

  if (by == "year") {
    tmp_tbl <- tidyr::separate(tmp_tbl, year, into = c("year", "month"))
    year_var <- sort(unique(tmp_tbl$year))

  } else {
    year_var <- sort(unique(tmp_tbl$year))
  }

  tmp_tbl <- tibble::as_tibble(aggregate(value ~ country + year, tmp_tbl, FUN = sum))
  tmp_tbl <- tidyr::spread(tmp_tbl, year, value)
  tmp_tbl <- dplyr::mutate_if(tmp_tbl, is.numeric, list(~ replace(., is.na(.), 0)))
  tmp_tbl <- tmp_tbl[order(tmp_tbl[[(length(year_var) + 1)]], decreasing = TRUE), ]

  # calculate sum of all countries
  tmp_tbl.global <- tmp_tbl
  tmp_tbl.global$group <- "\u5168\u7403"
  tmp_tbl.global <- tibble::as_tibble(
    aggregate(
      tmp_tbl.global[, 2:(length(year_var) + 1)],
      by = list(tmp_tbl.global$group),
      FUN = sum
    )
  )
  names(tmp_tbl.global) <- names(tmp_tbl)
  tmp_mix_tbl <- rbind(tmp_tbl.global, tmp_tbl)
  tmp_mix_tbl
}

