library(testthat)
library(predictr)

test_that("open markets are returned as tidy tibble", {
  x <- open_markets(nest = TRUE)
  expect_length(x, 4)
  expect_s3_class(x, "data.frame")
  expect_type(x$contracts, "list")
  expect_s3_class(x$time, "POSIXct")
  Sys.sleep(30)
})

test_that("open markets can be returned as list", {
  x <- open_markets(nest = FALSE)
  expect_length(x, 8)
  expect_s3_class(x, "data.frame")
  expect_s3_class(x$time, "POSIXct")
  expect_gt(length(unique(x$cid)), length(unique(x$mid)))
  Sys.sleep(30)
})
