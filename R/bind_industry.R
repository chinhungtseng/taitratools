#' Adding industry label to input data.frame
#'
#' @param .df A data frame. Input data.frame MUST contain `hscode` column!
#' @param sub The digits of `hscode`. If you set the digit less than 11, alway remember summarise the value of Input data.
#' @param index Filter specified index.
#' @param type Filter specified type.
#' @param major Filter specified major.
#' @param minor Filter specified minor.
#' @param industry_type "all_industry", "industry21", "version1", "version2"
#' @param col_more append type, major, minor and industry columns.
#' @param verbose TRUE or FALSE.
#'
#' @return A data frame
#'
#' @export
tt_bind_industry <- function(.df, sub = 11, index = NULL, type = NULL, major = NULL, minor = NULL,
  industry_type = "all_industry", col_more = FALSE, verbose = TRUE) {

  tmp_tbl <- .industry_tbl_en
  stop_if_df_not_contain(.df, c("hscode", "country", "year", "value"))

  if (!is.null(industry_type)) {
    stopifnot(check_industry_type(industry_type))
    switch (industry_type,
      industry21 = {tmp_tbl <- tmp_tbl[tmp_tbl[["index"]] %in% .tt_ind21_list, ]},
      version1 = {tmp_tbl <- tmp_tbl[tmp_tbl[["index"]] %in% .tt_ind_list_verion_1, ]},
      version2 = {tmp_tbl <- tmp_tbl[tmp_tbl[["index"]] %in% .tt_ind_list_verion_2, ]}
    )
  } else {
    # Filter by index
    if (!is.null(index)) {
      if (!all(stringr::str_length(index) == 3)) {stop("Invalid index string-length!", call. = FALSE)}
      tmp_tbl <- tmp_tbl[tmp_tbl[["index"]] %in% index, ]
    }

    # Filter by type
    if (!is.null(type)) {
      type_for_check <- c(
        "\u8CA1\u653F\u90E8\u5B9A\u7FA9\u7522\u696D",
        "\u5176\u4ED6\u7522\u696D\u5B9A\u7FA9", "5+2\u7522\u696D",
        "BEC", "\u5168\u90E8\u7522\u54C1",
        "\u8CA1\u653F\u90E8\u5B9A\u7FA9\u7522\u696D-54\u7D30\u9805"
      )
      if (!all(type %in% type_for_check)) {stop("Invalid tyep string!", call. = FALSE)}
      tmp_tbl <- tmp_tbl[tmp_tbl[["type"]] %in% type, ]
    }

    # Filter by major
    if (!is.null(major)) {
      major_list <- unique(tmp_tbl[["major"]])
      if (!all(major %in% major_list)) {stop("Invalid major string!", call. = FALSE)}
      tmp_tbl <- tmp_tbl[tmp_tbl[["major"]] %in% major, ]
    }

    # Filter by minor
    if (!is.null(minor)) {
      minor_list <- unique(tmp_tbl[["minor"]])
      if (!all(minor %in% minor_list)) {stop("Invalid minor string!", call. = FALSE)}
      tmp_tbl <- tmp_tbl[tmp_tbl[["minor"]] %in% minor, ]
    }
  }

  # Only keey `hscode` and `industry` columns
  tmp_tbl <- tmp_tbl[c("type", "major", "minor", "hscode", "industry")]
  output <- vector("list", length = nrow(tmp_tbl))
  for (i in seq_along(output)) {
    if (verbose) print_with_time(sprintf("%s (%3s/%3s)", tmp_tbl[i, ][["industry"]], i, length(output)))
    output_pattern <- str2regex(tmp_tbl[i, ][["hscode"]], sep = ",", sub = sub)
    output_name <- tmp_tbl[i, ][["industry"]]

    if (output_name == "\u5168\u90E8\u7522\u54C1_\u5168\u90E8\u7522\u54C1") {
      output_pattern <- "[\\w\\W]+"
    }

    tmp_output <- .df[stringr::str_detect(.df$hscode, output_pattern), ]
    if (nrow(tmp_output) == 0) next()

    if (!col_more) {
      tmp_output$industry <- tmp_tbl[i, ][["industry"]]
    } else {
      tmp_output$index <- tmp_tbl[i, ][["index"]]
      tmp_output$type  <- tmp_tbl[i, ][["type" ]]
      tmp_output$major <- tmp_tbl[i, ][["major"]]
      tmp_output$minor <- tmp_tbl[i, ][["minor"]]
      tmp_output$industry <- tmp_tbl[i, ][["industry"]]
    }
    output[[i]] <- tmp_output
  }
  purrr::reduce(output, dplyr::bind_rows)
}

#' convert report_industry_name
#' @param major string
#' @param minor string
#'
#' @return string
#' @export
tt_convert_industry_name <- function(major, minor) {
  fixed_name <- function(name) stringr::str_replace(name, "^\\d{2}_", "")
  dplyr::if_else(stringr::str_detect(minor, "\u5168\u90e8\u7522\u54c1"), fixed_name(major), fixed_name(minor))
}

check_industry_type <- function(x) {
  contain_any_keywords(x, c("all_industry", "industry21", "version1", "version2"))
}

stop_if_df_not_contain <- function(x, must_have) {
  column_names <- names(x)
  if (!contain_all_keywords(column_names, must_contain_col <- must_have)) {
    missing_cols <- must_contain_col[!(must_contain_col %in% column_names)]
    stop("Input data.frame MUST contain column named ", paste0("`", missing_cols, "`", collapse = ", "), "!", call. = FALSE)
  }
}
