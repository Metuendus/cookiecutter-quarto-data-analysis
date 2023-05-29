clean_text <- function(col) {
  trimws(tolower(stri_trans_general(col,
                                    id = "Latin-ASCII")))
}

set_channels <- function(.data, sourceMediumCol) {
  .data %>%
    mutate(sourceMedium = tolower({{sourceMediumCol}})) %>% 
    separate({{sourceMediumCol}}, into = c("source",
                                           "medium"),
             sep = " / ",
             remove = FALSE) %>% 
    mutate(channel = case_when(
      grepl("direct.*(no.set|none)",
            {{sourceMediumCol}}) ~ "Direct",
      grepl("^organic$",
            medium) ~ "Organic Search",
      grepl("^(social|social-network|social-media|sm|social network|social media)$",
            medium) ~ "Social",
      grepl("email",
            medium) ~ "Email",
      grepl("affiliate",
            medium) ~ "Affiliates",
      grepl("referral",
            medium) ~ "Referral",
      grepl("^(cpc|ppc|paidsearch|facebook)$",
            medium) ~ "Paid Search",
      grepl("^(cpv|cpa|cpp|content-text)$",
            medium) ~ "Other Advertising",
      grepl("^(display|cpm|banner)$",
            medium) ~ "Display",
      TRUE ~ "(other)"
    ))
}
