# TODO

tt_bind_industry_parallel <- function(.df, sub = 11, ind21 = FALSE, index = NULL, type = NULL, major = NULL, minor = NULL, col_more = FALSE) {
  if (!all("hscode" %in% names(.df))) {
    stop("Input data.frame MUST contain a column named `hscode`!", call. = FALSE)
  }

  tmp_tbl <- .industry_tbl

  if (nrow(tmp_tbl) != 354 & ncol(tmp_tbl) != 9) {
    stop("The Industry Table must be changed! Please check and update SOURCE_PATH!", call. = FALSE)
  }

  if (ind21) {
    if (!check_ind21(tmp_tbl)) {
      stop(sprintf("Industry21 reference table may be changed. Please check and update `%s`!", tt_get_path("PATH_INDUSTRY")), call. = FALSE)
    }
    tmp_tbl <- tmp_tbl[tmp_tbl[["\u7DE8\u865F"]] %in% .tt_ind21_list, ]

  } else {
    # Filter by index
    if (!is.null(index)) {
      if (!all(stringr::str_length(index) == 3)) {
        stop("Invalid index string-length!", call. = FALSE)
      }

      tmp_tbl <- tmp_tbl[tmp_tbl[["\u7DE8\u865F"]] %in% index, ]
    }

    # Filter by type
    if (!is.null(type)) {
      type_for_check <- c(
        "\u8CA1\u653F\u90E8\u5B9A\u7FA9\u7522\u696D",
        "\u5176\u4ED6\u7522\u696D\u5B9A\u7FA9", "5+2\u7522\u696D",
        "BEC", "\u5168\u90E8\u7522\u54C1",
        "\u8CA1\u653F\u90E8\u5B9A\u7FA9\u7522\u696D-54\u7D30\u9805"
      )

      if (!all(type %in% type_for_check)) {
        stop("Invalid tyep string!", call. = FALSE)
      }

      tmp_tbl <- tmp_tbl[tmp_tbl[["\u9078\u64C7\u65B9\u5F0F"]] %in% type, ]
    }

    # Filter by major
    if (!is.null(major)) {
      major_list <- unique(tmp_tbl[["\u5927\u9805"]])

      if (!all(major %in% major_list)) {
        stop("Invalid major string!", call. = FALSE)
      }

      tmp_tbl <- tmp_tbl[tmp_tbl[["\u5927\u9805"]] %in% major, ]
    }

    # Filter by minor
    if (!is.null(minor)) {
      minor_list <- unique(tmp_tbl[["\u7D30\u9805"]])

      if (!all(minor %in% minor_list)) {
        stop("Invalid minor string!", call. = FALSE)
      }

      tmp_tbl <- tmp_tbl[tmp_tbl[["\u7D30\u9805"]] %in% minor, ]
    }
  }

  # Only keey `hscode` and `industry` columns
  tmp_tbl <- tmp_tbl[c("\u9078\u64C7\u65B9\u5F0F", "\u5927\u9805", "\u7D30\u9805", "hscode", "industry")]
  output <- vector("list", length = nrow(tmp_tbl))

  for (i in seq_along(output)) {
    print_with_time(sprintf("%s (%3s/%3s)", tmp_tbl[i, ][["industry"]], i, length(output)))

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
      tmp_output$type <- tmp_tbl[i, ][["\u9078\u64C7\u65B9\u5F0F"]]
      tmp_output$major <- tmp_tbl[i, ][["\u5927\u9805"]]
      tmp_output$minor <-tmp_tbl[i, ][["\u7D30\u9805"]]
      tmp_output$industry <- tmp_tbl[i, ][["industry"]]
    }

    output[[i]] <- tmp_output
  }

  purrr::reduce(output, dplyr::bind_rows)
}

check_ind21 <- function(.df) {
  # Package prestore industry 21 data.
  valid_tbl <- .tt_ind21_tbl
  # User's data.
  check_tbl <- .df

  # Extract industry 21 with same rule as prestore data.
  check_tbl <- check_tbl[check_tbl[["\u7DE8\u865F"]] %in% valid_tbl[["\u7DE8\u865F"]], ]
  check_tbl <- check_tbl[c("\u7DE8\u865F", "industry")]

  # If two data are same, return TRUE, else return FALSE.
  return(identical(valid_tbl, check_tbl))
}
