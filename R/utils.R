undollar <- function(x) {
  as.numeric(gsub("^\\$", "", x))
}

as_tibble <- function(x) {
  if (is_installed("tibble")) {
    tibble::as_tibble(x)
  } else {
    x
  }
}

is_installed <- function(pkg) {
  isTRUE(requireNamespace(pkg, quietly = TRUE))
}

api_time <- function(x) {
  out <- as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%S", tz = "America/New_York")
  attr(out, "tzone") <- "UTC"
  out
}
