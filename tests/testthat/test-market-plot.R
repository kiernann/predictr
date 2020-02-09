library(testthat)
library(predictr)

test_that("market history plot can be made", {
  x <- market_history(3633)
  p <- market_plot(x)
  expect_s3_class(p, "ggplot")
})

test_that("market history plot can be made", {
  x <- market_price(6405)
  p <- market_plot(x)
  expect_s3_class(p, "ggplot")
})
