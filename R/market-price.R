#' Current market prices
#'
#' @param id The integer market ID.
#' @return A data frame of market contracts prices.
#' @examples
#' market_price(id = 6653)
#' @importFrom httr GET content accept_json
#' @export
market_price <- function(id) {
  resp <- httr::RETRY(
    verb = "GET",
    url = paste0("https://www.predictit.org/api/marketdata/markets/", id),
    httr::accept_json()
  )
  dat <- httr::content(
    x = resp,
    as = "parsed",
    type = "application/json",
    encoding = "ASCII",
    flatten = TRUE,
    simplifyDataFrame = TRUE
  )

  names(dat$contracts)[1] <- "contract"
  dat$contracts$dateEnd <- api_time(dat$contracts$dateEnd)
  cont <- cbind(
    id = id,
    market = dat$name,
    shortMarket = dat$shortName,
    timeStamp = api_time(dat$timeStamp),
    dat$contracts
  )
  as_tibble(cont[, -c(7)])
}
