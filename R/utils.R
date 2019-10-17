NULL

print_with_time <- function(message) {
  if (message == "=") {
    message <- paste0(rep("=", 80), collapse = "")
  } else if (message == "-") {
    message <- paste0(rep("-", 80), collapse = "")
  } else {
    message
  }
  now <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[%s] %s\n", now, message))
}

# Backup files
backup <- function(dir) {
  old <- setwd(dir)
  on.exit(setwd(old), add = TRUE)

  dir_nm <- format(Sys.Date(), "%Y%m%d")
  dir.create(file.path("./backup", dir_nm), showWarnings = FALSE, recursive = TRUE)

  file_nm <- list.files(".", "zip$|csv$|sqlite$")
  file.rename(from = file.path(".", file_nm), to = file.path("./backup", dir_nm, file_nm))
}

# Clean files in dir with specified file format
cleanup <- function(dir, pattern = "*") {
  old <- setwd(dir)
  on.exit(setwd(old), add = TRUE)

  files <- list.files(".", pattern = pattern)
  file.remove(files)
}

# date, time utils ---------------------------------------------

# Convert "year" to date. ex> "2019" ==> "2019-01-01"
y2date <- function(.date_var) {
  as.Date(paste0(.date_var, "-01-01"), "%Y-%m-%d")
}

# Convert "year-month" to date. ex> "2019-01" ==> "2019-01-01"
ym2date <- function(.date_var) {
  as.Date(paste0(.date_var, "-01"), "%Y-%m-%d")
}

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
period_year <- get_period("year")

# get period by month
period_month <- get_period("month")

dsecond <- function(new, old) {
  round(as.numeric(new) - as.numeric(old), 3)
}

# -------------------------------------------------------------

# Split string by specify character.
str2regex <- function(x, sep = ",", sub = 1e2) {
  paste0("^", unique(
    stringr::str_sub(
      stringr::str_replace(
        unlist(stringr::str_split(x, sep)), " ", ""),
      1, sub)
  ), collapse = "|")
}

# Calculate ------------------------------------------------------------
# TODO
cal_growth_rate <- function(var1, var2, digits = 4) {
  diff <- var2 - var1
  round(diff / replace(var1, var1 == 0, NA) * 100, digits = digits)
}

cal_share <- function(var1, base, digits = 4) {
  round(var1 / base * 100, digits = digits)
}


