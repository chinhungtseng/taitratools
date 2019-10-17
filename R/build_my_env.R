#' Create two directories: `./data` and `./output`
#'
#' @return not return
#' @export
#'
build_my_env <- function() {
  create_data <- FALSE
  create_output <- FALSE

  if (!dir.exists("./data")) {
    create_data <- dir.create("./data")
  }

  if (!dir.exists("./output")) {
    create_output <- dir.create("./output")
  }

  output_console <- function(intput) {
    dplyr::if_else(intput, crayon::green("created!"), crayon::red("not created"))
  }

  cat(paste0(
    "\"./data\"   ==> ", output_console(create_data), "\n",
    "\"./output\" ==> ", output_console(create_output)
  ))
}


