#' Market price history
#'
#' Download a data frame of contract prices over time, either hourly or daily.
#' This chart data does not include a market name or numeric contract IDs, which
#' can be obtained from the list of all [open_markets()].
#'
#' @param mid Market ID.
#' @param hourly 24 hourly rows per contract? If not, 90 daily rows.
#' @return A data frame of market contract prices over time.
#' @examples
#' market_history(mid = 3698)
#' market_history(mid = 6653, hourly = TRUE)
#' @format A tibble with 8 variables:
#' \describe{
#'   \item{time}{The hour or day of price}
#'   \item{mid}{Market ID}
#'   \item{contract}{Question answers}
#'   \item{open}{Price at start of hour/day}
#'   \item{close}{Price at end of hour/day}
#'   \item{low}{Low price of hour/day}
#'   \item{high}{High price of hour/day}
#'   \item{volume}{Number of shares traded per hour/day}
#' }
#' @importFrom dplyr mutate select
#' @importFrom httr GET content
#' @importFrom readr cols col_character col_datetime col_number col_double
#' @export
market_history <- function(mid, hourly = FALSE) {
  resp <- httr::GET(
    url = "https://www.predictit.org/Resource/DownloadMarketChartData",
    query = list(
      marketid = mid,
      timespan = c("90d", "24h")[hourly + 1]
    )
  )
  dat <- httr::content(
    x = resp,
    as = "parsed",
    type = "text/csv",
    encoding = "ASCII",
    skip = 1,
    col_names = c("contract", "time", "open", "high", "low", "close", "volume"),
    col_types = readr::cols(
      contract = readr::col_character(),
      time = readr::col_datetime("%m/%d/%Y %H:%M:%S %p"),
      open = readr::col_number(),
      high = readr::col_number(),
      low = readr::col_number(),
      close = readr::col_number(),
      volume = readr::col_double()
    )
  )
  dat <- dplyr::mutate(dat, mid = as.integer(mid), .before = 1)
  dat[, c(3, 1:2, 4:8)]
}
