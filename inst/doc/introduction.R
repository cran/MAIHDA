## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
# install.packages("MAIHDA")
# # Or for the latest development version:
# # install.packages("remotes")
# # remotes::install_github("hdbt/MAIHDA")

## ----eval=FALSE---------------------------------------------------------------
# library(MAIHDA)
# 
# # Load the built-in NHANES dataset
# data("maihda_health_data")
# 
# # PVC compares variance across models, so both models must use the same
# # analytic sample. Keep complete cases for all variables used below.
# health_complete <- maihda_health_data[complete.cases(
#   maihda_health_data[, c("BMI", "Age", "Gender", "Race", "Education", "Poverty")]
# ), ]
# 
# # Fit the initial Null model with auto-generated strata
# model_null <- fit_maihda(
#   BMI ~ 1 + (1 | Gender:Race:Education),
#   data = health_complete,
#   engine = "lme4"
# )
# 
# # Summarize the variance components (VPC)
# summary_null <- summary(model_null)
# print(summary_null)

## ----eval=FALSE---------------------------------------------------------------
# # Fit an adjusted model
# model_adj <- fit_maihda(
#   BMI ~ Age + Gender + Race + Education + Poverty + (1 | Gender:Race:Education),
#   data = health_complete
# )
# 
# # Calculate PCV with Parametric Bootstrap Confidence Intervals
# pcv_result <- calculate_pvc(model_null, model_adj, bootstrap = TRUE, n_boot = 500)
# print(pcv_result)

## ----eval=FALSE---------------------------------------------------------------
# # Run a stepwise variance decomposition using the prepared data with strata
# stepwise_results <- stepwise_pcv(
#   data = model_null$original_data,
#   outcome = "BMI",
#   vars = c("Age", "Gender", "Race", "Education", "Poverty")
# )
# 
# print(stepwise_results)

## ----eval=FALSE---------------------------------------------------------------
# # Predicted stratum values with 95% CIs
# plot(model_adj, type = "predicted")
# 
# # Variance partition (VPC) visualization
# plot(model_adj, type = "vpc")
# 
# # Bivariate risk against stratum-level intersectional effect
# plot(model_adj, type = "risk_vs_effect")
# 
# # Additive versus Intersectional Effect decomposition
# plot(model_adj, type = "effect_decomp")
# 
# # Ternary Plot of Variances
# plot(model_adj, type = "ternary")
# 
# # Individual Prediction Deviance Dashboard
# plot(model_adj, type = "prediction_deviation")

## ----eval=FALSE---------------------------------------------------------------
# # Launch the interactive interface
# run_maihda_app()

