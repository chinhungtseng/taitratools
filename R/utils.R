#' print_with_time
#'
#' @param message string
#'
#' @return NULL
#' @export
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

#' contain_any_keywords
#'
#' @param x object
#' @param ... keywords
#'
#' @return logical
#' @export
contain_any_keywords <- function(x, ...) {
  any(c(...) %in% x)
}

#' contain_all_keywords
#'
#' @param x object
#' @param ... keywords
#'
#' @return logical
#' @export
contain_all_keywords <- function(x, ...) {
  all(c(...) %in% x)
}
