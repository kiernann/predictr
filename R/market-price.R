#' Current market prices
#'
#' @param mid The integer market ID.
#' @return A data frame of market contracts prices.
#' @examples
#' market_price(mid = 3633)
#' market_price(mid = 6400)
#' market_price(mid = 6360)
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
#' @importFrom dplyr select mutate
#' @importFrom lubridate as_datetime as_date
#' @export
market_price <- function(mid) {
  api <- paste0("https://www.predictit.org/api/marketdata/markets/", mid)
  raw <- tibble::as_tibble(jsonlite::fromJSON(api))
  raw$timeStamp <- lubridate::as_datetime(raw$timeStamp)
  con <- raw$contracts
  con$shortName <- contract_convert(con$shortName)
  con <- cbind(
    con,
    time = raw$timeStamp,
    mid = raw$id,
    market = raw$shortName,
    end = raw$contracts$dateEnd
  )
  con <- con[, c(14, 15, 16, 1, 5, 7, 12, 17)]
  names(con)[4:7] <- c("cid", "contract", "last", "close")
  if (all(con$end == "N/A") | all(is.na(con$end))) {
    con <- con[, -8]
  } else {
    con$end <- lubridate::as_date(con$end)
  }
  tibble::as_tibble(con)
}
