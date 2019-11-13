library(taitratools)
library(testthat)

test_that("check sources name correct", {
  expect_match(names(.tt_source_path), regexp = "^NAS_|^SOURCE_|^PATH_")
})
