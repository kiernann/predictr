library(testthat)
library(predictr)

test_that("discrete market price returns", {
  x <- market_history(mid = 3633)
  expect_length(x, 8)
  expect_s3_class(x, "tbl")
  expect_length(unique(x$mid), 1)
  expect_s3_class(x$time, "POSIXct")
})
