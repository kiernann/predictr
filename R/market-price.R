#' Single market prices
#'
#' @param mid The integer market ID.
#' @return A data frame of market contracts prices.
#' @examples
#' market_price(mid = 3633)
#' market_price(mid = 6400)
#' market_price(mid = 6360)
#' @importFrom tibble as_tibble
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr select mutate
#' @importFrom lubridate as_datetime as_date
#' @export
market_price <- function(mid) {
  api <- paste0("https://www.predictit.org/api/marketdata/markets/", mid)
  raw <- tibble::as_tibble(jsonlite::fromJSON(api))
  raw$timeStamp <- lubridate::as_datetime(raw$timeStamp)
  con <- tibble::as_tibble(raw$contracts)
  if (all(grepl("%", con$shortName))) {
    con$shortName <- contract_interval(con$shortName)
  } else if (any(grep("\\d+\\s-\\s\\d+", con$shortName))) {
    con$shortName <- contract_interval(con$shortName)
  } else {
    con$shortName <- as.factor(con$shortName)
  }
  con <- dplyr::mutate(
    .data = con,
    time = raw$timeStamp,
    mid = raw$id,
    market = raw$shortName,
    end = raw$contracts$dateEnd
  )
  con <- dplyr::select(
    .data = con,
    time,
    mid,
    market,
    cid = id,
    contract = shortName,
    last = lastTradePrice,
    # buy_yes = bestBuyYesCost,
    # buy_no = bestBuyNoCost,
    # sell_yes = bestSellYesCost,
    # sell_no = bestSellNoCost,
    close = lastClosePrice,
    end,
  )
  if (all(raw$contracts$dateEnd == "N/A")) {
    dplyr::select(con, -end)
  } else {
    dplyr::mutate(con, end = lubridate::as_date(raw$contracts$dateEnd))
  }
}

#' Convert contract names to factor intervals
#'
#' @param x A character vector of interval contract names.
#' @return A factor vector.
#' @examples
#' contract_interval(c("1%-", "4%+", "2% - 3%", "1% - 2%", "3% - 4%"))
#' contract_interval(c("219-", "220 - 229", "240+",  "230 - 239"))
#' @importFrom stringr str_remove_all str_replace
#' @export
contract_interval <- function(x) {
  perc <- any(stringr::str_detect(x, "%"))
  x <- stringr::str_remove_all(x, "%")
  if (perc) {
    x <- stringr::str_replace(x, "(\\d+)-$", "[0, \\1)")
    x <- stringr::str_replace(x, "(\\d+)\\s-\\s(\\d+)", "[\\1, \\2)")
  } else {
    x <- stringr::str_replace(x, "(\\d+)-$", "[0, \\1]")
    x <- stringr::str_replace(x, "(\\d+)\\s-\\s(\\d+)", "[\\1, \\2]")
  }
  x <- stringr::str_replace(x, "(\\d+)\\+$", "[\\1, Inf)")
  as.factor(x)
}
