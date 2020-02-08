
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
market_price(mid = 3633)
#> # A tibble: 33 x 7
#>    time                  mid market                     cid contract  last close
#>    <dttm>              <int> <chr>                    <int> <fct>    <dbl> <dbl>
#>  1 2020-02-08 18:07:53  3633 2020 Democratic nominee?  7725 Sanders   0.45  0.44
#>  2 2020-02-08 18:07:53  3633 2020 Democratic nominee? 13871 Bloombe…  0.23  0.22
#>  3 2020-02-08 18:07:53  3633 2020 Democratic nominee? 14769 Buttigi…  0.17  0.18
#>  4 2020-02-08 18:07:53  3633 2020 Democratic nominee?  7729 Biden     0.13  0.13
#>  5 2020-02-08 18:07:53  3633 2020 Democratic nominee?  7730 Warren    0.05  0.07
#>  6 2020-02-08 18:07:53  3633 2020 Democratic nominee? 13491 Clinton   0.04  0.04
#>  7 2020-02-08 18:07:53  3633 2020 Democratic nominee?  7734 Klobuch…  0.03  0.02
#>  8 2020-02-08 18:07:53  3633 2020 Democratic nominee? 14670 Yang      0.02  0.04
#>  9 2020-02-08 18:07:53  3633 2020 Democratic nominee?  7726 Booker    0.01  0.01
#> 10 2020-02-08 18:07:53  3633 2020 Democratic nominee?  7727 Harris    0.01  0.01
#> # … with 23 more rows
```

<!-- refs: start -->

<!-- refs: end -->
