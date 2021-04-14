library(testthat)
library(predictr)

test_that("discrete market price returns", {
  dat <- market_price(id = 3633)
  expect_length(dat, 16)
  expect_s3_class(dat, "data.frame")
  expect_s3_class(dat$timeStamp, "POSIXct")
  expect_s3_class(dat$dateEnd, "POSIXct")
})
