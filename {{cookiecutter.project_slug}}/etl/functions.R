if (!require("pacman")) install.packages("pacman")
pacman::p_load(
      stringi,
      tidyverse
)

clean_text <- function(col) {
      trimws(tolower(stri_trans_general(col,
            id = "Latin-ASCII"
      )))
}