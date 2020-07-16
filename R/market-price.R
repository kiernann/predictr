#' Current market prices
#'
#' @param mid The integer market ID.
#' @return A data frame of market contracts prices.
#' @examples
#' market_price(mid = 6653)
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
#' @importFrom httr GET content
#' @importFrom dplyr select mutate bind_cols
#' @importFrom readr parse_datetime
#' @export
market_price <- function(mid) {
  api <- paste0("https://www.predictit.org/api/marketdata/markets/", mid)
  resp <- httr::GET(api)
  dat <- httr::content(
    x = resp,
    as = "parsed",
    type = "application/json",
    encoding = "ASCII",
    flatten = TRUE,
    simplifyDataFrame = TRUE
  )
  dat <- dplyr::bind_cols(
    time = readr::parse_datetime(dat$timeStamp, na = "N/A"),
    mid = dat$id,
    market = dat$shortName,
    fix_con(dat$contracts)
  )
  dat$contract[which(dat$contract == dat$market)] <- NA_character_
  return(dat)
}
