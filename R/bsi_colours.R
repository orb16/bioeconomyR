#' Palettes derived from BSI brand colours
#'
#' A named list of palettes used by [get_pal()] and [print_pal()].
#'
#' @format A named list of character vectors (hex colours).
#' @usage bsi_palettes
#' @export

bsi_palettes <- list(
  classic = c("#00424a", "#80ffb4", "#dbfaff", "#fdf479"),
  secondary_dark = c("#c75115", "#2f8941", "#146c37",
                     "#1d7e9e", "#005692", "#ae5886", "#783e80"),
  secondary_light = c("#ffa12e", "#a2f380", "#47cd75",
                      "#5dcee6", "#0394c1", "#f0b0d2", "#af7fb5")
)


#' Get a BSI palette
#'
#' @param name Palette name. One of `names(bsi_palettes)`.
#' @param n Optional number of colours to return (first `n`).
#' @param reverse Logical; reverse the palette order.
#' @return A character vector of hex colours.
#' @export
#' @examples
#' get_pal("classic")
#' get_pal("secondary_dark", n = 3)
get_pal <- function(name, n = NULL, reverse = FALSE) {
  name <- match.arg(name, choices = names(bsi_palettes))
  pal <- bsi_palettes[[name]]

  if (reverse) pal <- rev(pal)

  if (!is.null(n)) {
    n <- as.integer(n)
    if (is.na(n) || n < 1) stop("`n` must be a positive integer.")
    if (n > length(pal)) stop("`n` is larger than the palette length.")
    pal <- pal[seq_len(n)]
  }

  pal
}

#' Plot a colour palette
#'
#' @param x Either a palette name (character length 1) or a vector of colours.
#' @param labels What to label each swatch with:
#'   - `"none"`: no labels
#'   - `"index"`: 1, 2, 3, ...
#' @param ... Reserved for future use.
#' @return Invisibly returns the colour vector.
#' @export
#' @examples
#' print_pal("classic")
#' print_pal(get_pal("secondary_dark", n = 5))
print_pal <- function(x, labels = c("index", "none"), ...) {
  labels <- match.arg(labels)

  # Allow palette name
  if (is.character(x) && length(x) == 1 && x %in% names(bsi_palettes)) {
    x <- get_pal(x)
  }

  if (!is.character(x)) stop("`x` must be a palette name or a character vector of colours.")
  n <- length(x)
  if (n == 0) stop("No colours to plot.")

  old <- graphics::par(mar = c(0.6, 0.6, 0.6, 0.6))
  on.exit(graphics::par(old), add = TRUE)

  graphics::plot.new()
  graphics::plot.window(xlim = c(0, n), ylim = c(0, 1), xaxs = "i", yaxs = "i")

  # Draw swatches
  for (i in seq_len(n)) {
    graphics::rect(i - 1, 0, i, 1, col = x[i], border = NA)
  }

  # Labels with white boxes (readable on dark/light colours)
  if (labels == "index") {
    labs <- as.character(seq_len(n))
    for (i in seq_len(n)) {
      graphics::rect(i - 0.92, 0.35, i - 0.08, 0.65, col = "white", border = "white")
      graphics::text(i - 0.5, 0.5, labels = labs[i], col = "black", cex = 0.85)
    }
  }

  invisible(x)
}


#' ggplot2 fill scale using BSI palettes
#'
#' @param palette Palette name. One of `names(bsi_palettes)`.
#' @param n Optional number of colours to use.
#' @param reverse Logical; reverse palette order.
#' @param ... Passed to ggplot2's `discrete_scale()`.
#' @export
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(iris, ggplot2::aes(Sepal.Length, Sepal.Width, fill = Species)) +
#'     ggplot2::geom_point(shape = 21, colour = "black", size = 2) +
#'     scale_fill_bsi("classic", n = 3)
#' }
scale_fill_bsi <- function(palette = "classic", n = NULL, reverse = FALSE, ...) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for scale_fill_bsi(). Please install it.")
  }

  pal <- function(n_needed) {
    cols <- get_pal(palette, reverse = reverse)
    if (!is.null(n)) cols <- get_pal(palette, n = n, reverse = reverse)
    if (n_needed > length(cols)) stop("Not enough colours in palette for the number of levels.")
    cols[seq_len(n_needed)]
  }

  ggplot2::discrete_scale("fill", paste0("bsi_", palette), palette = pal, ...)
}

#' ggplot2 colour scale using BSI palettes
#'
#' @param palette Palette name. One of `names(bsi_palettes)`.
#' @param n Optional number of colours to use.
#' @param reverse Logical; reverse palette order.
#' @param ... Passed to ggplot2's `discrete_scale()`.
#' @export
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   ggplot2::ggplot(iris, ggplot2::aes(Sepal.Length, Sepal.Width, colour = Species)) +
#'     ggplot2::geom_point(size = 2) +
#'     scale_colour_bsi("classic", n = 3)
#' }
scale_colour_bsi <- function(palette = "classic", n = NULL, reverse = FALSE, ...) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for scale_colour_bsi(). Please install it.")
  }

  pal <- function(n_needed) {
    cols <- get_pal(palette, reverse = reverse)
    if (!is.null(n)) cols <- get_pal(palette, n = n, reverse = reverse)
    if (n_needed > length(cols)) stop("Not enough colours in palette for the number of levels.")
    cols[seq_len(n_needed)]
  }

  ggplot2::discrete_scale("colour", paste0("bsi_", palette), palette = pal, ...)
}
