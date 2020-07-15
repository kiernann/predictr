#' List all open markets
#'
#' @param split Split into a list of market data frames?
#' @return A data frame or list of market contracts prices.
#' @examples
#' open_markets(split = FALSE)
#' @format A tibble with 8 variables:
#' \describe{
#'   \item{time}{The hour or day of price}
#'   \item{mid}{Market ID}
#'   \item{market}{Market question}
#'   \item{cid}{Contract ID}
#'   \item{contract}{Question answers}
#'   \item{last}{Most recent trading price of the contract}
#'   \item{close}{Price at the end of the previous midnight EST}
#'   \item{end}{The date and time which the market closes}
#' }
#' @importFrom httr GET content
#' @importFrom readr parse_datetime
#' @importFrom tibble as_tibble
#' @importFrom tidyr unnest
#' @export
open_markets <- function(split = FALSE) {
  resp <- httr::GET("https://www.predictit.org/api/marketdata/all/")
  dat <- httr::content(
    x = resp,
    as = "parsed",
    type = "application/json",
    encoding = "ASCII",
    flatten = TRUE,
    simplifyDataFrame = TRUE
  )
  dat <- tibble::as_tibble(dat$markets)
  dat <- dat[, c(7, 1, 3, 6)]
  names(dat)[1:3] <- c("time", "mid", "market")
  dat <- tidyr::unnest(data = dat, col = "contracts")
  dat <- dat[, c(1:4, 8, 10, 15, 5)]
  names(dat)[4:8] <- c("cid", "contract", "last", "close", "end")
  dat$contract[which(dat$contract == dat$market)] <- NA_character_
  dat$time <- readr::parse_datetime(dat$time)
  dat$end <- readr::parse_datetime(dat$end, na = "N/A")
  if (split) {
    split(dat, dat$mid)
  } else {
    return(dat)
  }
}
