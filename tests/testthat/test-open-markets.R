library(testthat)
library(predictr)

test_that("multiplication works", {
  dat <- open_markets()
  expect_length(dat, 11)
  expect_s3_class(dat, "tbl")
  expect_s3_class(dat$time, "POSIXct")
})
