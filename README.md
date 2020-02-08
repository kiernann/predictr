
<!-- README.md is generated from README.Rmd. Please edit that file -->

# predictr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/predictr)](https://CRAN.R-project.org/package=predictr)
[![Travis build
status](https://travis-ci.org/kiernann/predictr?branch=master)](https://travis-ci.org/kiernann/predictr)
[![Codecov test
coverage](https://codecov.io/gh/kiernann/predictr/branch/master/graph/badge.svg)](https://codecov.io/gh/kiernann/predictr?branch=master)
<!-- badges: end -->

The goal of predictr is to access the price of binary contracts trading
on the [PredictIt](https://www.predictit.org/) prediction market. The
price of these contracts represents the crowdsourced probability of
these events occuring.

## Installation

You can install the development version from [GitHub]() with:

``` r
# install.packages("devtools")
devtools::install_github("kiernann/predictr")
```

## Usage

``` r
library(predictr)
open_markets()[, c(3, 5, 11)]
#> # A tibble: 1,288 x 3
#>    market                                   contract    close
#>    <chr>                                    <chr>       <dbl>
#>  1 Which party wins the Presidency in 2020? Republican   0.56
#>  2 Which party wins the Presidency in 2020? Democratic   0.44
#>  3 Which party wins the Presidency in 2020? Libertarian  0.02
#>  4 Which party wins the Presidency in 2020? Green        0.02
#>  5 Will Cuban run in 2020?                  <NA>         0.05
#>  6 Will Cuomo run in 2020?                  <NA>         0.05
#>  7 Woman president in 2020?                 <NA>         0.08
#>  8 Will the 2020 Dem nominee be a woman?    <NA>         0.1 
#>  9 Will the 2020 GOP nominee be a woman?    <NA>         0.03
#> 10 Will Zuckerberg run in 2020?             <NA>         0.02
#> # … with 1,278 more rows
```

<!-- refs: start -->

<!-- refs: end -->
