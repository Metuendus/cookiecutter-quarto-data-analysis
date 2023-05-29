# load_libraries ----------------------------------------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
    configr,
    googleAnalyticsR,
    glue,
    tidyverse
)

# read_settings -----------------------------------------------------------
settings <- read.config(file = "settings.toml")
ga_auth(email = settings$ga$auth_email)
sampling <- TRUE
quotas <- FALSE

# data_dictionary ------------------------------------------------------------
data_dict <- list(
    # Acquisition Overview
    acquisition_overview = list(
        dimensions = c(
            "ga:date",
            "ga:sourceMedium"
        ),
        metrics = c(
            "ga:sessions",
            "ga:users",
            "ga:newUsers",
            "ga:bounces",
            "ga:pageviews",
            "ga:sessionDuration",
            "ga:transactions",
            "ga:transactionRevenue"
        )
    ),

    # Demographics
    demographics = list(
        dimensions = c(
            "ga:date",
            "ga:userAgeBracket",
            "ga:userGender"
        ),
        metrics = c(
            "ga:sessions",
            "ga:users",
            "ga:bounces",
            "ga:sessionDuration",
            "ga:transactions",
            "ga:transactionRevenue"
        )
    ),
    # Products
    products = list(
        dimensions = c(
            "ga:date",
            "ga:productName"
        ),
        metrics = c(
            "ga:productListViews",
            "ga:productDetailViews",
            "ga:productAddsToCart",
            "ga:productCheckouts",
            "ga:uniquePurchases",
            "ga:itemRevenue"
        )
    )
)

# extract_data ------------------------------------------------------------
analytics_data <- lapply(names(data_dict), function(dataset) {
    if (is.null(data_dict[[dataset]][["dim_filters"]])) {
        response <- google_analytics(
            viewId = settings[["ga"]][["view_id"]],
            date_range = settings[["ga"]][["dates"]],
            dimensions = data_dict[[dataset]][["dimensions"]],
            metrics = data_dict[[dataset]][["metrics"]],
            max = -1,
            anti_sample = sampling,
            useResourceQuotas = quotas
        )
        response$dataset <- dataset
        return(response)
    }
    response <- google_analytics(
        viewId = settings[["ga"]][["view_id"]],
        date_range = settings[["ga"]][["dates"]],
        dimensions = data_dict[[dataset]][["dimensions"]],
        dim_filters = data_dict[[dataset]][["dim_filters"]],
        metrics = data_dict[[dataset]][["metrics"]],
        max = -1,
        anti_sample = sampling,
        useResourceQuotas = quotas
    )
    response$dataset <- dataset
    return(response)
})

# write_data --------------------------------------------------------------
save(analytics_data,
    file = glue('data/1-raw/ga_data_{settings[["ga"]][["view_id"]]}_{settings[["ga"]][["dates"]]}.Rdata')
)
