#' Filter data by area
#'
#' @param .df A data frame
#' @param area A character vector
#'
#' @return data frame
#'
#' @export
tt_filter_by_area <- function(.df, area) {
  stopifnot(is.data.frame(.df))
  stopifnot(!is.null(area))

  if (!all("country" %in% names(.df))) {
    stop("Input data.frame MUST contain a column named `country`!", call. = FALSE)
  }

  if (length(area) == 1) {
    if (stringr::str_detect(area, ",")) {
      area <- unlist(strsplit(area, ","))
    }
  }

  tmp_tbl <- tt_read_table(tt_get_path("PATH_AREA"))
  tmp_tbl <- tmp_tbl[tmp_tbl$areaName %in% area, ]
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
