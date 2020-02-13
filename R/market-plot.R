#' Plot market types
#'
#' @param data A data frame created by either [market_history()] or
#'   [market_price()]. For price history plots, [ggplot2::geom_line()] is used;
#'   for current prices, [ggplot2::geom_col()] is used.
#' @param color The number of current top contracts lines highlighted if `data`
#'   is daily or hourly.
#' @return A ggplot object.
#' @examples
#' market_plot(market_history(3633), color = 4)
#' market_plot(market_price(6405))
#' @importFrom ggplot2 ggplot aes_string geom_col scale_fill_viridis_d
#'   scale_y_continuous theme element_blank geom_line scale_color_brewer
#' @importFrom scales dollar
#' @export
market_plot <- function(data, color = 4) {
  bar <- length(unique(data$time)) == 1
  if (bar) {
    ggplot2::ggplot(data, ggplot2::aes_string(x = "contract")) +
      ggplot2::geom_col(ggplot2::aes_string(y = "close", fill = "close")) +
      ggplot2::scale_fill_viridis_c(end = 0.5, guide = FALSE) +
      ggplot2::scale_y_continuous(labels = scales::dollar) +
      ggplot2::theme(panel.grid.major.x = ggplot2::element_blank()) +
      ggplot2::labs(
        title = unique(data$market),
        caption = paste("Source: PredictIt", unique(data$mid)),
        x = "Contract",
        y = "Closing Price"
      )
  } else {
    td <- data$time == (Sys.Date() - 1)
    con_td <- data$contract[td]
    top_close <- sort(data$close[td], decreasing = TRUE)[1:color]
    top_con <- data$contract[td][data$close[td] %in% top_close]
    data_color <- data[data$contract %in% top_con, ]
    ggplot2::ggplot(data_color, ggplot2::aes_string(x = "time", y = "close")) +
      ggplot2::geom_line(data = data, ggplot2::aes_string(group = "contract"), alpha = 0.5) +
      ggplot2::geom_line(ggplot2::aes_string(color = "contract"), size = 2) +
      ggplot2::scale_color_brewer(palette = "Dark2") +
      ggplot2::scale_y_continuous(labels = scales::dollar) +
      ggplot2::theme(legend.position = "bottom") +
      ggplot2::labs(
        title = unique(data$market),
        caption = paste("Source: PredictIt", unique(data$mid)),
        color = "Contract",
        x = "Contract",
        y = "Closing Price"
      )
  }
}
