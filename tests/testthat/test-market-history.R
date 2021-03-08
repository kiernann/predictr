test_that("discrete market price returns", {
  x <- market_history(id = 3633)
  expect_length(x, 7)
  expect_s3_class(x, "data.frame")
  expect_s3_class(x$Date, "POSIXct")
})
