# TODO Adding some common
getsourcepath <- function() {
  tmp_path <- readxl::read_xlsx("inst/extdata/tt_source_path.xlsx")
  .tt_source_path <- as.list(tmp_path$path)
  names(.tt_source_path) <- tmp_path$name
  save(.tt_source_path, file = "R/sysdata.rda", compress='xz')
}

tt_update_data <- function() {
  # tt_source_path data -------------------------
  tmp_path <- readxl::read_xlsx("inst/extdata/tt_source_path.xlsx")
  .tt_source_path <- as.list(tmp_path$path)
  names(.tt_source_path) <- tmp_path$name

  # industry data -----------------------------
  .industry_tbl <- tt_read_table(tt_get_path("PATH_INDUSTRY")) %>%
    dplyr::mutate_at(dplyr::vars("reports_version_industry21", "reports_version_1", "reports_version_2"), list(~ tidyr::replace_na(., 0)))


  .industry_tbl_en <- rlang::set_names(.industry_tbl, c("index", "type", "major", "minor", "hscode6", "hscode11", "hscode_dights",
    "hscode", "industry", "reports_version_1", "reports_version_1_order", "reports_version_2",
    "reports_version_2_order", "reports_version_2_ind_name", "reports_version_industry21", "reports_version_industry21_order",
    "reports_version_3",
    "reports_version_3_order", "reports_version_3_ind_name"))

  # industry21 data -----------------------------
  .tt_ind21_list <- .industry_tbl[.industry_tbl[["reports_version_industry21"]] == 1, ][["\u7DE8\u865F"]]
  .tt_ind21_tbl <- .industry_tbl[.industry_tbl[["\u7DE8\u865F"]] %in% .tt_ind21_list, ][c("\u7DE8\u865F", "industry", "reports_version_industry21_order")]
  .tt_ind21_tbl_en <- .industry_tbl_en[.industry_tbl_en[["index"]] %in% .tt_ind21_list, ][c("index", "industry", "reports_version_industry21_order")]

  # industry version 1 data -----------------------------
  .tt_ind_list_verion_1 <- .industry_tbl[.industry_tbl[["reports_version_1"]] == 1, ][["\u7DE8\u865F"]]
  .tt_ind_verion_1_tbl <- .industry_tbl[.industry_tbl[["\u7DE8\u865F"]] %in% .tt_ind_list_verion_1, ][c("\u7DE8\u865F", "industry", "reports_version_1_order")]
  .tt_ind_verion_1_tbl_en <- .industry_tbl_en[.industry_tbl_en[["index"]] %in% .tt_ind_list_verion_1, ][c("index", "industry", "reports_version_1_order")]

  # industry version 2 data -----------------------------
  .tt_ind_list_verion_2 <- .industry_tbl[.industry_tbl[["reports_version_2"]] == 1, ][["\u7DE8\u865F"]]
  .tt_ind_verion_2_tbl <- .industry_tbl[.industry_tbl[["\u7DE8\u865F"]] %in% .tt_ind_list_verion_2, ][c("\u7DE8\u865F", "industry", "reports_version_2_order")]
  .tt_ind_verion_2_tbl_en <- .industry_tbl_en[.industry_tbl_en[["index"]] %in% .tt_ind_list_verion_2, ][c("index", "industry", "reports_version_2_order")]

  # full hsocde data -----------------------------
  .full_hscode_tbl <- tt_read_table(tt_get_path("PATH_FULL_HSCODE"))
  tmp <- lapply(list(1:2, 3:4, 5:6, 7:8, 9:10), function(x) {
    tmp <- unique(.full_hscode_tbl[x])
    names(tmp) <- c("hscode", "hscode_cn")
    tmp
  })
  .full_hscode_tbl <- Reduce(rbind, tmp)

  # area data -------------------------------------
  .area_tbl <- tt_read_table(tt_get_path("PATH_AREA"))
  .area_tbl[.area_tbl$areaName == "全球", ][["countryName"]] <- "[\\w\\W]+"

  # country name data -----------------------------
  .country_ref_list <- readxl::read_xlsx("//172.26.1.102/dstore/重要資料/國家中英文對照.xlsx", skip = 1)
  name_var <- c(
    "name_ch",                                         # chinese name
    paste0("mof.",         c("name", "code", "area")), # MOF
    paste0("itc.",         c("name", "code")),         # ITC
    paste0("world_bank.",  c("name", "code", "area")), # WORLD BANK
    paste0("imf.",         c("name")),                 # IMF
    paste0("oxford.",      c("name")),                 # OXFORD
    paste0("un_comtrade.", c("name", "code", "iso")),  # UN COMTRADE
    paste0("gta.",         c("name")),                 # GTA
    paste0("itc_tariff.",  c("name")),                 # ITC TARIFF
    paste0("asean.",       c("name", "code")),         # ASEAN
    "name_ch2"                                         # same as name_ch
  )
  names(.country_ref_list) <- name_var

  .mof_export_usd_sample_data <- tt_vroom_mof("2019-01", "2019-02", period = 3, dep_month_cols = TRUE)

  # save data ------------------------------------
  save(
    .tt_source_path, .industry_tbl, .industry_tbl_en,
    .tt_ind21_tbl, .tt_ind21_tbl_en, .tt_ind21_list,
    .tt_ind_verion_1_tbl_en, .tt_ind_list_verion_1,
    .tt_ind_verion_2_tbl_en, .tt_ind_list_verion_2,
    .full_hscode_tbl, .area_tbl, .country_ref_list,
    .mof_export_usd_sample_data,
    file = "R/sysdata.rda", compress='xz')
}

getsourcepath()
tt_update_data()
