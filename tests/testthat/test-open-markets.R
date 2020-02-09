library(testthat)
library(predictr)

test_that("open markets are returned as tidy tibble", {
  x <- open_markets()
  expect_length(x, 8)
  expect_s3_class(x, "data.frame")
  expect_s3_class(x$time, "POSIXct")
  expect_gt(length(unique(x$cid)), length(unique(x$mid)))
})

test_that("open markets can be returned as list", {
  x <- open_markets(split = TRUE)
  expect_type(x, "list")
})
