
<!-- README.md is generated from README.Rmd. Please edit that file -->

# predictr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/predictr)](https://CRAN.R-project.org/package=predictr)
[![Travis build
status](https://travis-ci.org/kiernann/predictr.svg?branch=master)](https://travis-ci.org/kiernann/predictr)
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
library(tidyverse)
library(predictr)
market_price(mid = 6403) %>% arrange(contract)
#> # A tibble: 9 x 7
#>   time                  mid market                      cid contract  last close
#>   <dttm>              <int> <fct>                     <int> <ord>    <dbl> <dbl>
#> 1 2020-02-09 10:15:49  6403 NH primary margin of vic… 20984 [0,4)     0.43  0.47
#> 2 2020-02-09 10:15:49  6403 NH primary margin of vic… 20988 [4,5)     0.17  0.17
#> 3 2020-02-09 10:15:49  6403 NH primary margin of vic… 20990 [5,6)     0.14  0.15
#> 4 2020-02-09 10:15:49  6403 NH primary margin of vic… 20991 [6,7)     0.09  0.08
#> 5 2020-02-09 10:15:49  6403 NH primary margin of vic… 20985 [7,8)     0.08  0.09
#> 6 2020-02-09 10:15:49  6403 NH primary margin of vic… 20986 [8,9)     0.04  0.06
#> 7 2020-02-09 10:15:49  6403 NH primary margin of vic… 20987 [9,10)    0.03  0.04
#> 8 2020-02-09 10:15:49  6403 NH primary margin of vic… 20992 [10,11)   0.04  0.03
#> 9 2020-02-09 10:15:49  6403 NH primary margin of vic… 20989 [11,Inf)  0.11  0.09
```

``` r
market_history(mid = 3633) %>% 
  filter(contract %in% c("Sanders", "Biden", "Bloomberg", "Buttigieg")) %>% 
  ggplot(aes(x = time, y = close)) +
  geom_line(aes(color = contract), size = 2) +
  scale_y_continuous(labels = scales::dollar) +
  theme(legend.position = "bottom") +
  labs(title = "Democratic nominee", color = "Contract", y = "Price", x = "Date")
```

<img src="man/figures/README-plot-market-1.png" width="100%" />

<!-- refs: start -->

<!-- refs: end -->
