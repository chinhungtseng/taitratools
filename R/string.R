# Split string by specify character.
#' @export
str2regex <- function(x, sep = ",", sub = 1e2, start = "^", end = "") {
  tmp <- trimws(unlist(strsplit(x, sep)))
  tmp <- unique(substr(tmp, 1, sub))
  tmp <- tmp[tmp != ""]
  paste0(start, tmp, end, collapse = "|")
}

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

#' @export
toChString <- function(x = "") {
  if (length(x) == 1) return(x)
  paste0(
    paste(x[1:length(x) - 1], collapse = "\u3001"),
    "\u53ca", x[length(x)]
  )
}
