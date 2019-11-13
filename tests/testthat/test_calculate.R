context("calculate")

test_df <- data.frame(
  country = c("A", "B", "C", "D"),
  year2017 = c(200, 300, 400, 500),
  year2018 = c(100, 200, 300, 400),
  year2019 = rep(200, 4)
)

test_that("cal_growth_rate", {
  expect_equivalent(
    cal_growth_rate(test_df$year2019, test_df$year2018),
    c(100.0000, 0.0000, -33.3333, -50.0000)
  )
})

test_that("cal_share", {
  expect_equivalent(
    cal_share(test_df$year2018, sum(test_df$year2018)),
    c(10, 20, 30, 40)
  )
})

test_that("cal_cagr", {
  expect_equivalent(
    cal_cagr(test_df$year2019, test_df$year2017, 2),
    c(0.0000, -18.3503, -29.2893, -36.7544)
  )
})
