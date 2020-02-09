library(testthat)
library(predictr)

test_that("market history plot can be made", {
  p <- market_plot(mid = 3633, type = "line")
  expect_s3_class(p, "ggplot")
})

test_that("market history plot can be made", {
  p <- market_plot(mid = 6405, type = "bar")
  expect_s3_class(p, "ggplot")
})
