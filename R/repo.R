repo_last_version <- function() {
  repo_tags_url = "https://api.github.com/repos/chinhungtseng/taitratools/tags"
  response = httr::GET(repo_tags_url)

  if (response$status_code == 200L) {
    repo_tags = jsonlite::read_json(repo_tags_url)
    version = repo_tags[[1]]$name
    return(gsub("v", "", version))
  }
  return(-1)
}

pkg_curr_version <- function() {
  package_info = utils::packageDescription("taitratools")
  return(package_info$Version)
}

check_pkg_update <- function() {
  # Return True if new package is released, False otherwise.
  newest_version <- repo_last_version()
  if (newest_version == -1) {
    return(newest_version)
  }

  curr_version <- pkg_curr_version()
  return(newest_version > curr_version)
}
