if (!require("pacman")) install.packages("pacman")
pacman::p_load(formattable,
               highcharter,
               tidyverse)

color_palette <- c("#115cfa",
                            "#b7b7b7",
                            "Set3")

epa_theme <- hc_theme(
  colors = c("#115cfa",
                      "#edae49",
                      "#ed254e",
                      "#23ce6b",
                      "#ea9010",
                      "#70d6ff",
                      "#261447",
                      "#b7b7b7"
  ),
  chart = list(
    backgroundColor = "transparent"
  ),
  title = list(
    style = list(
      color = "#333333",
      fontFamily = "IBM Plex Sans"
    )
  ),
  subtitle = list(
    style = list(
      color = "#bdbdbd",
      fontFamily = "IBM Plex Sans"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = "IBM Plex Sans",
      color = "black"
    ),
    itemHoverStyle = list(
      color = "gray"
    )
  )
)

int_format <- function(x) {
  comma(x, digits = 0)
}