# load_libraries ----------------------------------------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
    arrow,
    glue,
    stringi,
    tidyverse
)
source("etl/functions.R")


# load_data ---------------------------------------------------------------
load(glue('data/1-raw/ga_data_{settings[["ga"]][["view_id"]]}_{settings[["ga"]][["dates"]]}.Rdata'))

for (i in seq(length(analytics_data))) {
    print(analytics_data[[i]][["dataset"]][1])
    assign(
        paste0(
            "raw_",
            analytics_data[[i]][["dataset"]][1]
        ),
        analytics_data[[i]] %>%
            select(-dataset)
    )
}
# data_processing ---------------------------------------------------------
data <- list()
# acquisition_overview
data <- data %>%
    append(list(
        acquisition_overview = raw_acquisition_overview %>%
            set_channels(sourceMedium) %>%
            group_by(
                date,
                channel,
                sourceMedium
            ) %>%
            summarise_if(is.numeric, sum, na.rm = TRUE)
    ))

# demographics
data <- data %>%
    append(
        list(
            demographics = raw_demographics
        )
    )
# products
data <- data %>%
    append(
        list(
            products = raw_products
        )
    )

# save_clean_data ---------------------------------------------------------
lapply(names(data), function(dataset) {
    write_feather(
        x = data[[dataset]],
        sink = glue(
            "data/2-processed/{dataset}.feather"
        )
    )
})
