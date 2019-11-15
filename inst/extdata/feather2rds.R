
path <- tt_get_path("SOURCE_MIX")

feather2rds <- function(path) {
  on.exit(rm(tmp_file), add = TRUE)
  if (!stringr::str_detect(path, "\\.feather$")) stop("file format is not '.feather!'", call. = FALSE)
  nm <- gsub("\\.feather", "\\.rds", path)
  tmp_file <- feather::read_feather(path)
  readr::write_rds(tmp_file, nm)
}

feather2rds(path)
