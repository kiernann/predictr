library(testthat)
library(predictr)

test_that("discrete market price returns", {
  dat <- market_price(mid = 3633)
  expect_length(dat, 7)
  expect_s3_class(dat, "tbl")
})

test_that("percentage interval market price returns with factors", {
  dat <- market_price(mid = 6360)
  expect_length(dat, 7)
  expect_s3_class(dat, "tbl")
})

test_that("integer interval market price returns with end date", {
  dat <- market_price(mid = 6400)
  expect_length(dat, 8)
  expect_s3_class(dat, "tbl")
})
