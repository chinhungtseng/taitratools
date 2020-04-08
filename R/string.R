# Split string by specify character.

#' Compare two hscode is the same
#'
#' @param x hscode vector 1
#' @param y hscode vector 2
#' @param sub integer. The last element to be replaced.
#'
#' @return string
#' @export
tt_compare_hscode <- function(x, y, sub = NULL) {
  objs <- lapply(list(x, y), function(z) {tt_format_hscode(z, sub = sub, collapse = NULL)})
  x_bn_y <- objs[[1]][!(objs[[1]] %in% objs[[2]])]
  y_bn_x <- objs[[2]][!(objs[[2]] %in% objs[[1]])]

  if (length(c(x_bn_y, y_bn_x)) == 0) cat("Hscode is same!\n")

  cat("Hscode in x but not in y is: ", paste0(x_bn_y, collapse = ","), "\n",
    "Hscode in y but not in x is: ", paste0(y_bn_x, collapse = ","), "\n", sep = "")
}

#' format hscode
#'
#' @param x hscode charactor
#' @param sub integer. The last element to be replaced.
#' @param start a character
#' @param end a character
#' @param collapse an optional character string to separate the results.
#' @param .order order
#'
#' @return string
#' @export
tt_format_hscode <- function(x, sub = NULL, start = "", end = "", collapse = ",", .order = TRUE) {
  stopifnot(length(x) >= 1)
  stopifnot((is.numeric(sub) && sub >= 1) | is.null(sub))
  str <- gsub("\u3001", ",", x)
  str <- unique(trimws(unlist(strsplit(str, ","))))
  str <- str[str != ""]

  if (.order) str <- sort(str)
  if (!is.null(sub)) str <- unique(substr(str, 1, sub))
  if (is.null(collapse)) return(str)
  paste0(start, str, end, collapse = collapse)
}

#' str2regex
#'
#' @param x hscode string
#'
#' @param sep a
#' @param sub a
#' @param start a
#' @param end a
#'
#' @return string
#' @export
str2regex <- function(x, sep = ",", sub = 1e2, start = "^", end = "") {
  tmp <- trimws(unlist(strsplit(x, sep)))
  tmp <- unique(substr(tmp, 1, sub))
  tmp <- tmp[tmp != ""]
  paste0(start, tmp, end, collapse = "|")
}


#' break_line
#'
#' @param text a
#' @param length a
#'
#' @return string
#' @export
break_line <- function(text, length = 25) {
  stopifnot(length(text) == 1)
  text <- as.character(text)

  if (nchar(text) <= length) return(text)
  tmp_text <- list()

  while (!nchar(text) <= length) {
    tmp_text <- append(tmp_text, list(substr(text, 1, length)))
    text <- substr(text, (length + 1), nchar(text))
  }
  tmp_text <- append(tmp_text, list(text))
  Reduce(function(.x, .y) {
    paste0(.x, "\n", .y)
  }, tmp_text)
}


#' toChString
#'
#' @param x a
#'
#' @return a
#' @export
toChString <- function(x = "") {
  if (length(x) == 1) return(x)
  paste0(
    paste(x[1:length(x) - 1], collapse = "\u3001"),
    "\u53ca", x[length(x)]
  )
}
