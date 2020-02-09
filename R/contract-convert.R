#' Convert contract names to factor intervals
#'
#' @param x A character vector of contract names.
#' @return A factor vector intervals in proper notation.
#' @examples
#' contract_convert(c("3%-", "12%+", "9% - 12%", "3% - 6%", "6% - 9%"))
#' contract_convert(c("219-", "220 - 229", "240+",  "230 - 239"))
#' contract_convert(c("Sanders", "Biden", "Warren", "Buttigieg"))
#' @importFrom stringr str_remove_all str_replace str_detect str_extract_all
#' @export
contract_convert <- function(x) {
  if (all(stringr::str_detect(x, "%"))) {
    x <- stringr::str_remove_all(x, "%")
    x <- stringr::str_replace(x, "(\\d+)-$", "[0,\\1)")
    x <- stringr::str_replace(x, "(\\d+)\\s-\\s(\\d+)", "[\\1,\\2)")
    x <- stringr::str_replace(x, "(\\d+)\\+$", "[\\1,Inf)")
    num <- TRUE
  } else if (any(stringr::str_detect(x, "^\\d+\\s-\\s\\d+$"))) {
    x <- stringr::str_replace(x, "(\\d+)-$", "[0,\\1]")
    x <- stringr::str_replace(x, "(\\d+)\\s-\\s(\\d+)", "[\\1,\\2]")
    x <- stringr::str_replace(x, "(\\d+)\\+$", "[\\1,Inf)")
    num <- TRUE
  } else {
    num <- FALSE
  }
  if (num) {
    z <- unique(x)
    a <- stringr::str_extract_all(z, "\\d+|Inf")
    a <- vapply(a, FUN = function(i) sum(as.numeric(i)), FUN.VALUE = double(1))
    a <- match(a, sort(a))
    factor(x, levels = z[order(sort(z)[a])], ordered = TRUE)
  } else {
    factor(x, ordered = FALSE)
  }
}
