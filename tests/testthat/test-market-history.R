library(testthat)
library(predictr)

test_that("discrete market price returns", {
  x <- market_history(mid = 3633)
  expect_length(x, 10)
  expect_s3_class(x, "tbl")
  expect_length(unique(x$mid), 1)
})

test_that("percentage interval market price returns with factors", {
  x <- market_history(mid = 6360, hourly = FALSE)
  expect_length(x, 10)
  expect_s3_class(x, "tbl")
  expect_s3_class(x$time, "Date")
})

test_that("hourly price history can be returned", {
  x <- market_history(mid = 5241, hourly = TRUE)
  expect_length(x, 10)
  expect_s3_class(x, "tbl")
  expect_s3_class(x$time, "POSIXct")
})
