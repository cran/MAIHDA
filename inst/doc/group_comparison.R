## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----data---------------------------------------------------------------------
library(MAIHDA)
data("maihda_country_data")

country_counts <- as.data.frame(table(maihda_country_data$country))
names(country_counts) <- c("country", "n")
country_counts

table(maihda_country_data$gender, maihda_country_data$ses)

## ----one-call-----------------------------------------------------------------
# gender + ses are written as additive fixed effects (the adjusted model); maihda()
# derives the null by dropping them, both overall and within each country.
analysis <- maihda(
  math ~ gender + ses + (1 | gender:ses),
  data = maihda_country_data,
  group = "country"
)

analysis

## ----group-table--------------------------------------------------------------
group_results <- as.data.frame(analysis$groups)
group_results[order(group_results$vpc, decreasing = TRUE),
              c("group", "n", "n_strata", "vpc", "var_between",
                "var_residual", "pcv", "status")]

## ----group-vpc-plot-----------------------------------------------------------
plot(analysis, type = "group_vpc")

## ----group-components-plot----------------------------------------------------
plot(analysis, type = "group_components")

## ----group-between-variance-plot----------------------------------------------
plot(analysis, type = "group_between_variance")

## ----group-pcv-plot-----------------------------------------------------------
plot(analysis, type = "group_pcv")

## ----direct-workflow, eval = FALSE--------------------------------------------
# group_cmp <- compare_maihda_groups(
#   math ~ 1 + (1 | gender:ses),
#   data = maihda_country_data,
#   group = "country"
# )
# 
# group_cmp
# plot(group_cmp, type = "vpc")
# plot(group_cmp, type = "components")
# plot(group_cmp, type = "pcv")

## ----bootstrap-example, eval = FALSE------------------------------------------
# group_cmp_boot <- compare_maihda_groups(
#   math ~ 1 + (1 | gender:ses),
#   data = maihda_country_data,
#   group = "country",
#   bootstrap = TRUE,
#   n_boot = 500
# )
# 
# plot(group_cmp_boot, type = "vpc")

