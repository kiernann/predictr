#' List all open markets
#'
#' @param nest Should the `contracts` column be nested per market?
#' @return A data frame of market contracts prices.
#' @examples
#' open_markets(nest = TRUE)
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
#' @export
open_markets <- function(nest = TRUE) {
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
  dat$time <- readr::parse_datetime(dat$time)
  dat$contracts <- lapply(dat$contracts, fix_con)
  if (!nest) {
    if (!requireNamespace("tidyr", quietly = TRUE)) {
      stop("Package \"tidyr\" needed to unnest contracts.", call. = FALSE)
    } else {
      dat <- tidyr::unnest(data = dat, col = "contracts")
      dat$contract[which(dat$contract == dat$market)] <- NA_character_
    }
  }
  return(dat)
}

fix_con <- function(con) {
  con <- con[, c(1, 5, 7, 12, 2, 13)]
  names(con) <- c("cid", "contract", "last", "close", "end", "order")
  if (is.logical(con$end)) {
    con$end <- readr::parse_datetime(NA_character_)
  } else {
    con$end <- readr::parse_datetime(con$end, na = "N/A")
  }
  con$contract <- factor(
    x = con$contract,
    levels = con$contract[order(con$order, con$contract)]
  )
  con <- con[order(con$order), -length(con)]
  tibble::as_tibble(con)
}
