library(testthat)
library(predictr)

test_that("discrete market price returns", {
  dat <- market_price(mid = 3633)
  expect_length(dat, 8)
  expect_s3_class(dat, "tbl")
  expect_s3_class(dat$time, "POSIXct")
  expect_s3_class(dat$end, "POSIXct")
})
