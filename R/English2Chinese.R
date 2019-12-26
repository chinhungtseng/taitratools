#' Convert English name to Chinese name
#'
#'
#' @param x data.frame
#' @param types only support itc, un_comtrade and asean now.
#'
#' @return data.frame
#' @export
#'
tt_English2Chinese <- function(x, types) {

  if (!any(stringr::str_detect(names(x), "^(c|C)ountry$"))) {
    stop("column name MUST contain `country`.", call. = FALSE)
  }

  types <- match.arg(
    types,
    c("itc", "itc_tariff", "gta", "un_comtrade", "asean", "world_bank", "oxford", "imf", "mof")
  )

  switch(types,
    itc = {
      cny_ref <- dplyr::select(.country_ref_list, name_ch, dplyr::contains(types))
      tmp_df <- dplyr::left_join(x, cny_ref, by = c("country" = "itc.name"))
      tmp_df <- dplyr::mutate(tmp_df, name_ch = dplyr::if_else(is.na(name_ch), country, name_ch))
      tmp_df <- dplyr::mutate(tmp_df, country = name_ch)
      dplyr::select(tmp_df, -name_ch, -itc.code, -itc_tariff.name)
    },
    un_comtrade = {
      cny_ref <- dplyr::select(.country_ref_list, name_ch, dplyr::contains(types))
      tmp_df <- dplyr::left_join(x, cny_ref, by = c("country" = "un_comtrade.name"))
      tmp_df <- dplyr::mutate(tmp_df, name_ch = dplyr::if_else(is.na(name_ch), country, name_ch))
      tmp_df <- dplyr::mutate(tmp_df, country = name_ch)
      dplyr::select(tmp_df, -name_ch, -un_comtrade.code, -un_comtrade.iso)
    },
    asean = {
      cny_ref <- dplyr::select(.country_ref_list, name_ch, dplyr::contains(types))
      tmp_df <- dplyr::left_join(x, cny_ref, by = c("country" = "asean.name"))
      tmp_df <- dplyr::mutate(tmp_df, name_ch = dplyr::if_else(is.na(name_ch), country, name_ch))
      tmp_df <- dplyr::mutate(tmp_df, country = name_ch)
      dplyr::select(tmp_df, -name_ch, -asean.code)
    },
    stop("not correct keyword!", call. = FALSE)
  )

}
