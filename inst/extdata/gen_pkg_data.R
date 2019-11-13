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

  # save data
  save(.tt_source_path, .tt_ind21_tbl, .industry_tbl, .tt_ind21_list, .full_hscode_tbl, .area_tbl, file = "R/sysdata.rda")
}

getsourcepath()
tt_update_data()
