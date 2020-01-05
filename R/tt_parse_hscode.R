#' tt_parse_hscode
#'
#' @param x a character of hscode
#'
#' @return a character of hscode chinese name
#' @export
tt_parse_hscode <- function(x) {
  hs_check <- grepl("^\\d{2,11}$", x)
  stopifnot(all(hs_check))
  if (!all(is.character(x))) {
    x <- as.character(x)
  }
  # fixed hscode length
  hs_length <- nchar(x)
  if(!all(hs_length %% 2 == 0)) {
    index <- which(hs_length %% 2 != 0)
    fixed_hs <- unlist(lapply(index, function(i) {
      substr(x[i], 1, (nchar(x[i]) - 1))
    }))
    x[index] <- fixed_hs
  }

  hs_dic <- .full_hscode_tbl$hscode
  names(hs_dic) <- .full_hscode_tbl$hscode_cn
  names(unlist(lapply(x, function(x) which(hs_dic == x))))
}
