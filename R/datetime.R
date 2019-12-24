# date, time utils ---------------------------------------------

# Convert "year" to date. ex> "2019" ==> "2019-01-01"
#' @export
y2date <- function(.date_var, tf = "%Y-%m-%d") {
  tmp_date <- as.Date(paste0(.date_var, "-01-01"), "%Y-%m-%d")
  format(tmp_date, tf)
}

# Convert "year-month" to date. ex> "2019-01" ==> "2019-01-01"
#' @export
ym2date <- function(.date_var, tf = "%Y-%m-%d") {
  tmp_date <- as.Date(paste0(.date_var, "-01"), "%Y-%m-%d")
  format(tmp_date, tf)
}

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
