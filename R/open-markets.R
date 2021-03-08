#' List all open markets
#'
#' @return A data frame of markets with nested contract prices.
#' @examples
#' open_markets()
#' @importFrom httr RETRY content
#' @export
open_markets <- function() {
  resp <- httr::RETRY(
    verb = "GET",
    url = "https://www.predictit.org/api/marketdata/all/"
  )
  dat <- httr::content(
    x = resp,
    as = "parsed",
    type = "application/json",
    encoding = "ASCII",
    flatten = TRUE,
    simplifyDataFrame = TRUE
  )
  dat <- dat[[1]]
  dat$timeStamp <- api_time(dat$timeStamp)
  as_tibble(dat[, -c(4:5)])
}
