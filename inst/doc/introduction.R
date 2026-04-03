## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
#  # install.packages("devtools")
#  devtools::install_github("hdbt/MAIHDA")

## ----eval=FALSE---------------------------------------------------------------
#  library(MAIHDA)
#  
#  # Example dataset
#  data <- data.frame(
#    gender = sample(c("Male", "Female"), 1000, replace = TRUE),
#    race = sample(c("White", "Black", "Hispanic"), 1000, replace = TRUE),
#    age = rnorm(1000, 50, 10),
#    health_outcome = rnorm(1000, 100, 15)
#  )
#  
#  # Create strata
#  strata_result <- make_strata(data, vars = c("gender", "race"))
#  
#  # View stratum information
#  print(strata_result)

## ----eval=FALSE---------------------------------------------------------------
#  # Fit model with lme4 (default)
#  model <- fit_maihda(
#    health_outcome ~ age + (1 | stratum),
#    data = strata_result$data,
#    engine = "lme4"
#  )
#  
#  # View model
#  print(model)

## ----eval=FALSE---------------------------------------------------------------
#  # Basic summary
#  summary_result <- summary_maihda(model)
#  print(summary_result)
#  
#  # Summary with bootstrap confidence intervals
#  summary_boot <- summary_maihda(model, bootstrap = TRUE, n_boot = 500)
#  print(summary_boot)

## ----eval=FALSE---------------------------------------------------------------
#  # Individual-level predictions
#  pred_ind <- predict_maihda(model, type = "individual")
#  
#  # Stratum-level predictions
#  pred_strata <- predict_maihda(model, type = "strata")
#  head(pred_strata)

## ----eval=FALSE---------------------------------------------------------------
#  # Caterpillar plot of stratum random effects
#  plot_maihda(model, type = "caterpillar")
#  
#  # Variance partition visualization
#  plot_maihda(model, type = "vpc")
#  
#  # Observed vs. shrunken estimates
#  plot_maihda(model, type = "obs_vs_shrunken")

## ----eval=FALSE---------------------------------------------------------------
#  # Fit multiple models
#  model1 <- fit_maihda(health_outcome ~ age + (1 | stratum),
#                      data = strata_result$data)
#  model2 <- fit_maihda(health_outcome ~ age + gender + (1 | stratum),
#                      data = strata_result$data)
#  
#  # Compare models
#  comparison <- compare_maihda(
#    model1, model2,
#    model_names = c("Base Model", "With Gender"),
#    bootstrap = TRUE,
#    n_boot = 500
#  )
#  
#  print(comparison)
#  
#  # Plot comparison
#  plot_comparison(comparison)

## ----eval=FALSE---------------------------------------------------------------
#  # Fit model with brms
#  model_brms <- fit_maihda(
#    health_outcome ~ age + (1 | stratum),
#    data = strata_result$data,
#    engine = "brms",
#    chains = 2,
#    iter = 2000
#  )
#  
#  # Summary works the same way
#  summary_brms <- summary_maihda(model_brms)

