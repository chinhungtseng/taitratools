# TODO Adding some common
getsourcepath <- function() {
  tmp_path <- readxl::read_xlsx("inst/extdata/tt_source_path.xlsx")
  .tt_source_path <- as.list(tmp_path$path)
  names(.tt_source_path) <- tmp_path$name
  save(.tt_source_path, file = "R/sysdata.rda")
}

tt_update_data <- function() {
  # tt_source_path data
  tmp_path <- readxl::read_xlsx("inst/extdata/tt_source_path.xlsx")
  .tt_source_path <- as.list(tmp_path$path)
  names(.tt_source_path) <- tmp_path$name

  # industry21 data
  .industry_tbl <- tt_read_table(tt_get_path("PATH_INDUSTRY"))
  .tt_ind21_list <- .industry_tbl[.industry_tbl[["reports"]] == 1, ][["\u7DE8\u865F"]]

  .tt_ind21_tbl <- .industry_tbl[.industry_tbl[["\u7DE8\u865F"]] %in% .tt_ind21_list, ][c("\u7DE8\u865F", "industry")]

  # full hsocde data
  .full_hscode_tbl <- tt_read_table(tt_get_path("PATH_FULL_HSCODE"))
  tmp <- lapply(list(1:2, 3:4, 5:6, 7:8, 9:10), function(x) {
    tmp <- unique(.full_hscode_tbl[x])
    names(tmp) <- c("hscode", "hscode_cn")
    tmp
  })
  .full_hscode_tbl <- Reduce(rbind, tmp)

  # area data
  .area_tbl <- tt_read_table(tt_get_path("PATH_AREA"))
  .area_tbl[.area_tbl$areaName == "全球", ][["countryName"]] <- "[\\w\\W]+"

  # country name data
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
    "name_ch2"                                         # same as name_ch
  )
  names(.country_ref_list) <- name_var

  # save data
  save(.tt_source_path, .tt_ind21_tbl, .industry_tbl, .tt_ind21_list, .full_hscode_tbl, .area_tbl, .country_ref_list, file = "R/sysdata.rda")
}

getsourcepath()
tt_update_data()
