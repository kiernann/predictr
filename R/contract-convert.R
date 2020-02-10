#' Convert contract names to factor intervals
#'
#' Perfoms one of three conversions in [market_price()] and [market_history()]:
#' 1. For interval contracts (e.g., "220 - 229", "9% or more", etc.), convert
#' the character strings to proper interval notation.
#' 2. For contracts with multiple discrete outcomes (e.g., Candidate names),
#' convert the chracter vector to simple factors.
#' 3. For markets with a single binary question (e.g., "Will the Democrats have
#' a brokered convention in 2020?"), contracts returned are always "Yes" which
#' is converted to `TRUE`.
#'
#' @param x A character vector of contract names.
#' @param decimal Should percentages be converted to decimals?
#' @return A interval factor, unique factor, or logical vector.
#' @examples
#' contract_convert(c("4 or fewer", "8 or more", "5", "6", "7"))
#' contract_convert(c("3%-", "12%+", "9% - 12%", "3% - 6%", "6% - 9%"))
#' contract_convert(c("219-", "220 to 229", "240+",  "230 to 239"))
#' contract_convert(c("Sanders", "Biden", "Warren", "Buttigieg"))
#' contract_convert(c("Brokered convention?", "Brokered convention?"))
#' @importFrom stringr str_remove_all str_replace str_replace_all str_detect str_extract_all
#' @export
contract_convert <- function(x, decimal = FALSE) {
  rx <- "(\\d{1,3}(?:,\\d{3})*(?:\\.\\d+)?)"
  p <- all(stringr::str_detect(x, "%"))
  if (length(unique(x)) == 1) {
    return(TRUE)
  } else if (all(stringr::str_detect(x, "\\d", negate = TRUE))) {
    return(factor(x, ordered = FALSE))
  }
  x <- stringr::str_replace(x, "\\sor\\s(fewer|lower)", "-")
  x <- stringr::str_replace(x, "\\sor\\s(more|higher)", "+")
  x <- stringr::str_replace(x, "\\sto\\s", " - ")
  x <- stringr::str_remove_all(x, "[^[\\+\\d\\s\\.-]]")
  x <- stringr::str_remove(x, "(?<=\\d)(\\.0)(?=\\D)")
  if (any(stringr::str_detect(x, sprintf("^%s$", rx)))) {
    x <- stringr::str_replace(x, paste0(rx, "(?:-$)"), "[0,\\1]")
    x <- stringr::str_replace(x, paste0(rx, "(?:\\+$)"), "[\\1, Inf)")
    x <- stringr::str_replace(x, sprintf("^%s$", rx), "[\\1,\\1]")
  } else if (p) {
    x <- stringr::str_replace(x, paste0(rx, "(?:-$)"), "[0,\\1)")
    x <- stringr::str_replace(x, paste0(rx, "(?:\\+$)"), "[\\1,100]")
    x <- stringr::str_replace(x, paste(rx, "-", rx), "[\\1,\\2)")
    if (decimal) {
      x <- stringr::str_replace_all(x, rx, function(p) as.numeric(p)/100)
    }
  } else if (any(stringr::str_detect(x, paste(rx, "-", rx)))) {
    x <- stringr::str_replace(x, paste0(rx, "(?:-$)"), "[0,\\1]")
    x <- stringr::str_replace(x, paste(rx, "(?:-|to)", rx), "[\\1,\\2]")
    x <- stringr::str_replace(x, paste0(rx, "(?:\\+$)"), "[\\1, Inf)")
  }
  z <- unique(x)
  a <- stringr::str_extract_all(z, "(\\d{1,3}(?:\\.\\d+)?)|Inf")
  a <- vapply(a, FUN = function(i) sum(as.numeric(i)), FUN.VALUE = double(1))
  a <- match(a, sort(a))
  factor(x, levels = z[order(sort(z)[a])], ordered = TRUE)
}
