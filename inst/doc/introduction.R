## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
# install.packages("MAIHDA")
# # Or for the latest development version:
# # install.packages("remotes")
# # remotes::install_github("hamidbulut/MAIHDA")

## ----eval=FALSE---------------------------------------------------------------
# library(MAIHDA)
# 
# # Load the built-in NHANES dataset
# data("maihda_health_data")
# 
# # Create strata from Gender, Race, and Education
# strata_result <- make_strata(maihda_health_data, vars = c("Gender", "Race", "Education"))
# 
# # View the strata structural information
# print(strata_result)

## ----eval=FALSE---------------------------------------------------------------
# # Fit the initial Null model
# model_null <- fit_maihda(
#   BMI ~ 1 + (1 | stratum),
#   data = strata_result$data,
#   engine = "lme4"
# )
# 
# # Summarize the variance components (VPC)
# summary_null <- summary_maihda(model_null)
# print(summary_null)

## ----eval=FALSE---------------------------------------------------------------
# # Fit an adjusted model
# model_adj <- fit_maihda(
#   BMI ~ Age + Gender + Race + Education + Poverty + (1 | stratum),
#   data = strata_result$data
# )
# 
# # Calculate PCV with Parametric Bootstrap Confidence Intervals
# pcv_result <- calculate_pvc(model_null, model_adj, bootstrap = TRUE, n_boot = 500)
# print(pcv_result)

## ----eval=FALSE---------------------------------------------------------------
# # Run a stepwise variance decomposition
# stepwise_results <- stepwise_pcv(
#   data = strata_result$data,
#   outcome = "BMI",
#   vars = c("Age", "Gender", "Race", "Education", "Poverty")
# )
# 
# print(stepwise_results)

## ----eval=FALSE---------------------------------------------------------------
# # Caterpillar plot of stratum random effects (with 95% CIs)
# plot_maihda(model_adj, type = "caterpillar")
# 
# # Variance partition visualization
# plot_maihda(model_adj, type = "vpc")

## ----eval=FALSE---------------------------------------------------------------
# # Launch the interactive interface
# run_maihda_app()

