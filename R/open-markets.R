#' List all open markets
#'
#' @param split Should the data frame be split as a list of markets?
#' @return A data frame of market contracts prices.
#' @examples
#' open_markets(split = FALSE)
#' @format A tibble with 7 variables:
#' \describe{
#'   \item{time}{The hour or day of price}
#'   \item{mid}{Market ID}
#'   \item{market}{Market question}
#'   \item{cid}{Contract ID}
#'   \item{contract}{Question answers}
#'   \item{last}{Most recent trading price of the contract}
#'   \item{close}{Price at the end of the previous midnight EST}
#' }
#' @importFrom tibble as_tibble
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr select
#' @importFrom tidyr unnest
#' @importFrom lubridate as_datetime
#' @export
open_markets <- function(split = FALSE) {
  api <- "https://www.predictit.org/api/marketdata/all/"
  raw <- tibble::as_tibble(jsonlite::fromJSON(api)$markets)
  raw$timeStamp <- lubridate::as_datetime(raw$timeStamp)
  raw <- raw[, c(7, 1, 3, 6)]
  names(raw)[1:3] <- c("time", "mid", "market")
  all <- tidyr::unnest(data = raw, col = "contracts")
  all <- all[, c(1:4, 8, 10, 15, 5)]
  names(all)[4:8] <- c("cid", "contract", "last", "close", "end")
  all$contract[which(all$contract == all$market)] <- NA_character_
  all$end[which(all$end == "N/A")] <- NA
  all$end <- as.POSIXct(all$end)
  if (split) {
    dplyr::group_split(all, all$mid)
  } else {
    return(all)
  }
}
