#' Adding an area column to input data.frame
#'
#' The data.frame must contain a column named `country`.
#'
#' @param .df A data.frame
#'
#' @return A data.frame
#' @export
#'
tt_bind_area <- function(.df) {
  if (!all("country" %in% names(.df))) {
    stop("Input data.frame MUST contain a column named `country`!", call. = FALSE)
  }

  output <- vector("list", length = nrow(.area_tbl))

  for (i in seq_along(output)) {
    output_pattern <- str2regex(.area_tbl[i, ][["countryName"]], sep = ",")
    output_name <- .area_tbl[i, ][["areaName"]]

    if (output_name == "\u5168\u7403") {
      output_pattern <- "[\\w\\W]+"
    }

    tmp_output <- .df[stringr::str_detect(.df$country, output_pattern), ]
    if (nrow(tmp_output) == 0) next()
    tmp_output$area <- output_name
    output[[i]] <- tmp_output
  }

  purrr::reduce(output, dplyr::bind_rows)
}
