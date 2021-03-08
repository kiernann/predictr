test_that("open markets are returned as nested data frame", {
  x <- open_markets()
  expect_length(x, 6)
  expect_s3_class(x, "data.frame")
  expect_type(x$contracts, "list")
  expect_s3_class(x$timeStamp, "POSIXct")
})
