#' read_itc_file
#'
#' @param x file path
#'
#' @return data frame
#' @export
tt_read_itc_file <- function(x) {
  stopifnot(stringr::str_detect(x, "\\.xls"))

  doc <- xml2::read_html(x)
  doc_infos <- rvest::html_text(rvest::html_nodes(doc, "center"))
  doc_name <- stringr::str_replace_all(stringr::str_trim(doc_infos[1]), " ", "_")
  doc_units <- stringr::str_replace_all(rvest::html_text(
    rvest::html_nodes(doc, css = "#ctl00_PageContent_Label_Unit")
  )," ", "_")
  doc_product_group <- stringr::str_trim(gsub("Product group:", "", doc_infos[2]))
  doc_table <- rvest::html_nodes(doc, css = "#ctl00_PageContent_MyGridView1")
  doc_table <- tibble::as_tibble(as.data.frame(rvest::html_table(doc_table, fill = TRUE)))

  list(
    file_name = doc_name,
    units = doc_units,
    groups = doc_product_group,
    data = doc_table
  )
}
