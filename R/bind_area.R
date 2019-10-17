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

  tmp_tbl <- tt_read_table(tt_get_path("PATH_AREA"))
  output <- vector("list", length = nrow(tmp_tbl))

  for (i in seq_along(output)) {
    output_pattern <- str2regex(tmp_tbl[i, ][["countryName"]], sep = ",")
    output_name <- tmp_tbl[i, ][["areaName"]]

    if (output_name == "\u5168\u7403") {
      output_pattern <- "[\\w\\W]+"
    }

    tmp_output <- .df[stringr::str_detect(.df$country, output_pattern), ]
    tmp_output$area <- output_name
    output[[i]] <- tmp_output
  }

  purrr::reduce(output, dplyr::bind_rows)
}
