# Calculate ------------------------------------------------------------
#' @export
cal_growth_rate <- function(var1, var2, digits = 4) {
  diff <- var1 - var2
  round(diff / replace(var2, var2 == 0, NA) * 100, digits = digits)
}
#' @export
cal_share <- function(var1, base, digits = 4) {
  round(var1 / base * 100, digits = digits)
}
#' @export
cal_cagr <- function(var1, var2, period, digits = 4) {
  round(((var1 / replace(var2, var2 == 0, NA))^(1 / period) - 1) * 100, digits = digits)
}
