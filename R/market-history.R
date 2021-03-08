#' Market price history
#'
#' Download a data frame of contract prices over time, either hourly or daily.
#' This chart data does not include a market name or numeric contract IDs, which
#' can be obtained from the list of all [open_markets()].
#'
#' @param id Market ID number.
#' @param timespan One of "24h", "7d" or "90d". Either hourly or daily.
#' @return A data frame of market contract prices over time.
#' @examples
#' market_history(id = 3698)
#' market_history(id = 6653, timespan = "7d")
#' @importFrom httr RETRY content
#' @export
market_history <- function(id, timespan = c("24h", "7d", "90d")) {
  resp <- httr::RETRY(
    verb = "GET",
    url = "https://www.predictit.org/Resource/DownloadMarketChartData",
    query = list(marketid = id, timespan = match.arg(timespan))
  )
  dat <- httr::content(
    x = resp,
    as = "text",
    type = "text/csv",
    encoding = "ASCII"
  )
  con <- textConnection(dat)
  on.exit(con)
  dat <- read.csv(con)
  dat$Date <- as.POSIXct(dat$Date, tz = "EDT", format = "%m/%d/%Y %H:%M:%S")
  dat[, c(3:6)] <- lapply(dat[, c(3:6)], undollar)
  as_tibble(dat)
}

