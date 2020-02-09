#' Plot market types
#'
#' @param mid The integer market ID.
#' @param type One of "line" or "bar", calls either [market_history()] or
#'   [market_price()]. For price history plots, [ggplot2::geom_line()] is used;
#'   for current prices, [ggplot2::geom_col()] is used.
#' @param n If "line", the number of current top contracts lines highlight.
#' @return A ggplot object.
#' @examples
#' market_plot(mid = 3633, type = "line")
#' market_plot(mid = 6405, type = "bar")
#' @importFrom ggplot2 ggplot aes_string geom_col scale_fill_viridis_d
#'   scale_y_continuous theme element_blank geom_line scale_color_brewer
#' @importFrom scales dollar
#' @export
market_plot <- function(mid, type = c("line", "bar"), n = 4) {
  type <- match.arg(type, c("line", "bar"))
  if (type == "line") {
    data <- market_history(mid)
  } else {
    data <- market_price(mid)
  }
  if (type == "bar") {
    ggplot2::ggplot(data, ggplot2::aes_string(x = "contract")) +
      ggplot2::geom_col(ggplot2::aes_string(y = "close", fill = "contract")) +
      ggplot2::scale_fill_viridis_d(end = 0.5, guide = FALSE) +
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
    top_close <- sort(data$close[td], decreasing = TRUE)[1:n]
    top_con <- data$contract[td][data$close[td] %in% top_close]
    data_color <- data[data$contract %in% top_con, ]
    ggplot2::ggplot(data_color, ggplot2::aes_string(x = "time", y = "close")) +
      ggplot2::geom_line(data = data, ggplot2::aes_string(group = "contract"), alpha = 0.5) +
      ggplot2::geom_line(ggplot2::aes_string(color = "contract"), size = 2) +
      ggplot2::scale_color_brewer(palette = "Dark2") +
      ggplot2::scale_y_continuous(labels = scales::dollar) +
      ggplot2::labs(
        title = unique(data$market),
        caption = paste("Source: PredictIt", unique(data$mid)),
        color = "Contract",
        x = "Contract",
        y = "Closing Price"
      )
  }
}
