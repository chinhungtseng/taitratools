.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to taitratools package")
  # packageStartupMessage("Checking your package's version.")
  # pkg_update <- check_pkg_update()
  #
  # if (pkg_update == -1) {
  #   packageStartupMessage("API rate limit exceeded")
  # } else if (pkg_update) {
  #   packageStartupMessage("-> New version is released.")
  #   packageStartupMessage("-> please updgrade your taitatools package using below script:\n")
  #   packageStartupMessage('---> devtools::install_github("chinhungtseng/taitratools")\n')
  # } else {
  #   packageStartupMessage("-> Already up to date.")
  # }
}
