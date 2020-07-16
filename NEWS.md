# predictr 0.1.0

* All functions have been rewritten to use `httr::GET()` instead of attempting
to read the JSON or CSV files directly.
* The `market_history()` function now only makes a single request for the CSV
data, forgoing off the call to the API for the contract IDs and market question.
* `market_plot()` has been removed to reduce dependencies.
* Contract values are sorted by the `displayOrder` API value.
* All `contract_convert()` has been removed.

# predictr 0.0.2

* Create `market_plot()` using ggplot2.
* Order `market_price()` by contract factor.
* Set market names as character strings.
* Convert binary contracts to logical.

# predictr 0.0.1

* Create `market_history()`.
* Remove `dplyr` complexity to avoid global variables.
* Improve interval contract factorization.

# predictr 0.0.0.9001

* Create `market_price()` for a single market call.
* Implement factorization of interval contract names.
* Allow for `dplyr::group_split()` in `open_markets()`.

# predictr 0.0.0.9000

* Create `open_markets()` to list all in tidy data frane.
* Added a `NEWS.md` file to track changes to the package.
