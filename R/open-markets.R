#' List all open markets
#'
#' @return A data frame of market contracts prices.
#' @examples
#' open_markets()
#' @importFrom tibble as_tibble
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr select
#' @importFrom tidyr unnest
#' @importFrom lubridate as_datetime
#' @export
open_markets <- function() {
  api <- "https://www.predictit.org/api/marketdata/all/"
  raw <- tibble::as_tibble(jsonlite::fromJSON(api)$markets)
  raw$timeStamp <- lubridate::as_datetime(raw$timeStamp)
  all <- dplyr::select(
    .data = raw,
    time = timeStamp,
    mid = id,
    market = shortName,
    contracts
  )
  all <- tidyr::unnest(data = all, col = "contracts")
  all <- dplyr::select(
    .data = all,
    time,
    mid,
    market,
    cid = id,
    contract = shortName,
    last = lastTradePrice,
    buy_yes = bestBuyYesCost,
    buy_no = bestBuyNoCost,
    sell_yes = bestSellYesCost,
    sell_no = bestSellNoCost,
    close = lastClosePrice
  )
  all$contract[which(all$contract == all$market)] <- NA_character_
  return(all)
}
