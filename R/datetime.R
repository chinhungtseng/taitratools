# date, time utils ---------------------------------------------

#' y2date
#'
#' Convert "year" to date. ex> "2019" ==> "2019-01-01"
#' @param .date_var a
#'
#' @export
y2date <- function(.date_var) {
  as.Date(paste0(.date_var, "-01-01"), "%Y-%m-%d")
}

#' ym2date
#'
#' Convert "year-month" to date. ex> "2019-01" ==> "2019-01-01"
#' @param .date_var a
#'
#' @export
ym2date <- function(.date_var) {
  as.Date(paste0(.date_var, "-01"), "%Y-%m-%d")
}

#' get_past_year
#' @param .date_var a
#'
#' @param period a
#' @param tf a
#'
#' @export
get_past_year <- function(.date_var, period = 1, tf = "%Y-%m") {
  if (all(stringr::str_detect(.date_var, "^\\d{4}-\\d{2}$"))) {
    year <- ym2date(.date_var)

  } else if (all(stringr::str_detect(.date_var, "^\\d{4}$"))) {
    year <- y2date(.date_var)

  } else if (all(stringr::str_detect(.date_var, "^\\d{4}-\\d{2}-\\d{2}$"))) {
    year <- as.Date(.date_var)

  } else {
    stop("Invalid date format!", call. = FALSE)

  }

  format(year - period * 365, tf)
}

# Get the period of begin date and end date with specify type. type can be "year" or "month".
get_period <- function (type) {
  force(type)
  function(.begin, .end, format = "%Y-%m-%d") {
    begin <- ym2date(.begin)
    end <- ym2date(.end)
    format(seq(begin, end, by = type), format)
  }
}

# get period by year
#' @export
period_year <- get_period("year")

# get period by month
#' @export
period_month <- get_period("month")

dsecond <- function(new, old) {
  round(as.numeric(new) - as.numeric(old), 3)
}

#' Parse_date
#' Parse start date and end date
#' @param start_date yyyy-mm
#' @param end_date yyyy-mm
#' @param period integer
#'
#' @return a list
#' @export
tt_parse_date <- function(start_date, end_date, period = NA) {
  start_date <- ym2date(start_date)
  end_date <- ym2date(end_date)
  start_year <- format(start_date, "%Y")

  if (is.na(period)) {
    years <- end_year <- last_year <- NA
  } else {
    last_year <- get_past_year(start_date, 1, tf = "%Y")
    end_year <- get_past_year(start_date, period, tf = "%Y")
    years <- as.character(sort(seq(start_year, end_year)))
  }

  list(
    start_year = start_year,
    last_year = last_year,
    end_year = end_year,
    start_month = format(start_date, "%m"),
    end_month = format(end_date, "%m"),
    years = years,
    period = period
  )
}
