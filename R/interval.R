#' Convert contract names to factor intervals
#'
#' Can perform one of three **rough** conversions:
#' 1. For interval contracts (e.g., "220 - 229", "9% or more", etc.), convert
#' the character strings to proper interval notation.
#' 2. For contracts with multiple discrete outcomes (e.g., Candidate names),
#' convert the character vector to simple factors.
#' 3. For markets with a single binary question (e.g., "Will the Democrats have
#' a brokered convention in 2020?"), contracts returned are always "Yes" which
#' is converted to `TRUE`.
#'
#' @param x A character vector of contract names.
#' @return A interval factor, unique factor, or logical vector.
#' @examples
#' contract_convert(c("4 or fewer", "8 or more", "5", "6", "7"))
#' contract_convert(c("3%-", "12%+", "9% - 12%", "3% - 6%", "6% - 9%"))
#' contract_convert(c("219-", "220 to 229", "240+",  "230 to 239"))
#' contract_convert(c("Sanders", "Biden", "Warren", "Buttigieg"))
#' contract_convert(c("Brokered convention?", "Brokered convention?"))
#' @export
contract_convert <- function(x) {
  # regex for any number with separators
  rx <- "(\\d{1,3}(?:,\\d{3})*(?:\\.\\d+)?)"
  # check for percentafes before removing
  p <- all(grepl("%", x)) # check for percentages
  if (length(unique(x)) == 1) {
    # one value matches market name
    return(TRUE)
  } else if (all(!grepl("\\d", x))) {
    # return characters as factor
    return(factor(x, ordered = FALSE))
  }
  # replace words with symbols
  x <- gsub("\\sor\\s(fewer|lower)", "-", x)
  x <- gsub("\\sor\\s(more|higher)", "+", x)
  x <- gsub("\\sto\\s", " - ", x)
  # remove all non symbols/numbers
  x <- gsub("[^\\+\\d\\s\\.-]", "", x, perl = TRUE)
  # remove .0 decimal before non-number
  x <- gsub("(?<=\\d)(\\.0)(?=\\D)", "", x, perl = TRUE)
  # if any value is a single number
  if (any(grepl(sprintf("^%s$", rx), x))) {
    # place number before negative at the end
    x <- gsub(paste0(rx, "(?:-$)"), "[0,\\1]", x)
    # place number before positive at the start to inf
    x <- gsub(paste0(rx, "(?:\\+$)"), "[\\1, Inf)", x)
    # if only numbers put in own interval
    x <- gsub(sprintf("^%s$", rx), "[\\1,\\1]", x)
  } else if (p) { # if all percentages
    # place percentage inbetween 1 and 0
    x <- gsub(paste0(rx, "(?:-$)"), "[0,\\1)", x)
    x <- gsub(paste0(rx, "(?:\\+$)"), "[\\1,100]", x)
    x <- gsub(paste(rx, "-", rx), "[\\1,\\2)", x)
  } else if (any(grepl(paste(rx, "-", rx), x))) {
    x <- gsub(paste0(rx, "(?:-$)"), "[0,\\1]", x)
    x <- gsub(paste(rx, "(?:-|to)", rx), "[\\1,\\2]", x)
    x <- gsub(paste0(rx, "(?:\\+$)"), "[\\1, Inf)", x)
  }
  z <- unique(x)
  a <- regmatches(x, regexpr("(\\d{1,3}(?:\\.\\d+)?)|Inf", x))
  a <- vapply(a, FUN = function(i) sum(as.numeric(i)), FUN.VALUE = double(1))
  a <- match(a, sort(a))
  factor(x, levels = z[order(sort(z)[a])], ordered = TRUE)
}
