context("String")

library(taitratools)
library(testthat)

test_that("test str2regex", {
  expect_equal(str2regex("this,is,an,apple"), "^this|^is|^an|^apple")
  expect_equal(str2regex("this,is,an,apple", start = "", end = ""), "this|is|an|apple")
  expect_equal(str2regex("123456,234567,345678,456789", sub = 4), "^1234|^2345|^3456|^4567")
  expect_equal(str2regex("a,  b,  c,  d,  e"), "^a|^b|^c|^d|^e")
  expect_equal(str2regex("a&b&c&d&e", sep = "&"), "^a|^b|^c|^d|^e")
})

test_that("test break line", {
  expect_equal(
    break_line("I want to go to the pond, Mother, one baby duck quacked."),
    "I want to go to the pond,\n Mother, one baby duck qu\nacked."
  )

  expect_equal(
    break_line("Lets go!  Lets go! two more quacked excitedly.", length = 5),
    "Lets \ngo!  \nLets \ngo! t\nwo mo\nre qu\nacked\n exci\ntedly\n."
  )
})
