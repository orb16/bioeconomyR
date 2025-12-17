#' Palettes derived from BSI brand colours
#'
#' A named list of palettes used by [get_pal()] and [print_pal()].
#'
#' @format A named list of character vectors (hex colours).
#' @usage bsi_palettes
#' @export

bsi_palettes <- list(
  "classic" = c(slate = "#00424a", fresh_green = "#80ffb4",
                mist_blue = "#dbfaff", pollen_yellow = "#fdf479"),
  "secondary_dark" = c(orange = "#c75115", light_green = "#2f8941",
                       dark_green = "#146c37", light_blue = "#1d7e9e",
                       dark_blue = "#005692", pink = "#ae5886", purple = "#783e80"),
  "secondary_light" = c(orange = "#ffa12e", light_green = "#a2f380",
                        dark_green = '#47cd75', light_blue = "#5dcee6",
                        dark_blue = "#0394c1", pink = "#f0b0d2", purple = "#af7fb5")
)


#' Select a BSI palette
#'
#' @param name Palette name. One of `names(bsi_palettes)`.
#' @return A named character vector of hex colours.
#' @export
#' @examples
#' get_pal("secondary_dark")
#' get_pal("classic")
#' get_pal("secondary_light")
get_pal <- function(name) {
  name <- match.arg(name, choices = names(bsi_palettes))
  bsi_palettes[[name]]
}

#' Plot a colour palette
#'
#' @param x A vector of colours (e.g., hex codes).
#' @param ... Reserved for future use.
#' @return Invisibly returns `x`.
#' @export
print_pal <- function(x, ...) {
  n <- length(x)
  old <- graphics::par(mar = c(0.5, 0.5, 0.5, 0.5))
  on.exit(graphics::par(old), add = TRUE)

  graphics::image(
    1:n, 1, as.matrix(1:n),
    col = x, ylab = "", xaxt = "n", yaxt = "n", bty = "n"
  )

  invisible(x)
}
