#' Market price history
#'
#' Produce a data frame of contract prices over time, either hourly or daily.
#' For hourly tables, there is one row per contract per hour for the last 24
#' hours. For daily tables, one row per contract per day.
#'
#' @param mid The integer market ID.
#' @param hourly 24 hourly rows per contract be returned? If not, 90 daily rows.
#' @return A data frame of market contract prices over time.
#' @examples
#' market_history(mid = 3633)
#' market_history(mid = 6400)
#' @format A tibble with 10 variables:
#' \describe{
#'   \item{time}{The hour or day of price}
#'   \item{mid}{Market ID}
#'   \item{market}{Market question}
#'   \item{cid}{Contract ID}
#'   \item{contract}{Question answers}
#'   \item{open}{Price at start of hour/day}
#'   \item{close}{Price at end of hour/day}
#'   \item{low}{Low price of hour/day}
#'   \item{high}{High price of hour/day}
#'   \item{volume}{Number of shares traded per hour/day}
#' }
#' @importFrom tibble as_tibble
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr left_join mutate_at
#' @importFrom lubridate as_date mdy_hms
#' @importFrom stringr str_remove
#' @export
market_history <- function(mid, hourly = FALSE) {
  span <- c("24h", "90d")[c(hourly, !hourly)]
  hist <- utils::read.csv(
    file = sprintf("https://www.predictit.org/Resource/DownloadMarketChartData?marketid=%s&timespan=%s", mid, span),
    stringsAsFactors = FALSE,
    col.names = c("contract", "time", "open", "high", "low", "close", "volume")
  )
  hist <- dplyr::mutate_at(hist, 3:6, ~as.numeric(stringr::str_remove(., "\\$")))
  api <- paste0("https://www.predictit.org/api/marketdata/markets/", mid)
  raw <- jsonlite::fromJSON(api)
  con <- raw$contracts[, c(1, 5)]
  names(con) <- c("cid", "contract")
  market <- unique(raw$shortName)
  if (hourly & nrow(hist) < 24) {
    hist <- dplyr::mutate(hist, contract = NA_character_)
    hist <- dplyr::bind_rows(hist, con)
    hist <- dplyr::mutate(hist, mid, market, .before = 1)
    now_time <- lubridate::floor_date(Sys.time(), "hour")
    form_time <- format(now_time, "%m/%d/%Y %H:%M:%S %p")
    hist <- dplyr::mutate(hist, time = form_time)
  } else {
    hist <- cbind(mid, market, hist, stringsAsFactors = FALSE)
    hist <- dplyr::left_join(hist, con, by = "contract")
  }
  hist <- tibble::as_tibble(hist)
  if (hourly) {
    hist$time <- lubridate::mdy_hms(hist$time)
  } else {
    hist$time <- lubridate::as_date(lubridate::mdy_hms(hist$time))
  }
  hist[, c(4, 1:2, 10, 3, 5:9)]
}
