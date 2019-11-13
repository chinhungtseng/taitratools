
getsourcepath <- function() {
  tmp_path <- readxl::read_xlsx("inst/extdata/tt_source_path.xlsx")
  .tt_source_path <- as.list(tmp_path$path)
  names(.tt_source_path) <- tmp_path$name
  save(.tt_source_path, file = "R/sysdata.rda")
}
