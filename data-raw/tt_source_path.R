## code to prepare `tt_source_path` dataset goes here

tmp_path <- readxl::read_xlsx("inst/extdata/tt_source_path.xlsx")
tt_source_path <- as.list(tmp_path$path)
names(tt_source_path) <- tmp_path$name

usethis::use_data(tt_source_path)
