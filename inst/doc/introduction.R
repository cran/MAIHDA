## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----eval=FALSE---------------------------------------------------------------
# # Released version (CRAN):
# install.packages("MAIHDA")
# 
# # Development version (GitHub):
# # install.packages("remotes")
# # remotes::install_github("hdbt/MAIHDA")

## ----load---------------------------------------------------------------------
library(MAIHDA)
data("maihda_health_data")

# A few sections below add individual-level covariates (Age, Poverty) or compare
# variances across models.
health_complete <- maihda_health_data[complete.cases(
  maihda_health_data[, c("BMI", "Age", "Gender", "Race", "Education", "Poverty")]
), ]

## ----maihda-run---------------------------------------------------------------
analysis <- maihda(
  BMI ~ Gender + Race + Education + (1 | Gender:Race:Education),
  data = health_complete
)

analysis                # VPC/ICC (null) and PCV (null -> adjusted)
analysis$formula        # null:     BMI ~ (1 | stratum)
analysis$adjusted_formula  # adjusted: BMI ~ Gender + Race + Education + (1 | stratum)

## ----maihda-summary-----------------------------------------------------------
summary(analysis)       # variance components, VPC/ICC, stratum estimates
analysis$pcv            # proportional change in between-stratum variance

## ----maihda-plot-vpc----------------------------------------------------------
# Variance partition (VPC) -- null model
plot(analysis, type = "vpc")

## ----maihda-plot-predicted----------------------------------------------------
# Predicted stratum values with 95% CIs -- null model
plot(analysis, type = "predicted")

## ----maihda-plot-effect-decomp------------------------------------------------
# Additive versus intersectional effect decomposition -- adjusted model
plot(analysis, type = "effect_decomp")

## ----maihda-plot-risk---------------------------------------------------------
# Mean predicted outcome against the stratum random effect -- adjusted model
plot(analysis, type = "risk_vs_effect")

## ----maihda-plot-deviation, warning = FALSE-----------------------------------
# Individual prediction-deviance dashboard -- adjusted model
plot(analysis, type = "prediction_deviation")

## ----maihda-plot-ternary, eval = requireNamespace("ggtern", quietly = TRUE), warning = FALSE, message = FALSE----
# Ternary diagnostic: additive vs intersection-specific signal vs uncertainty
plot(analysis, type = "ternary")

## ----maihda-weighted, eval=FALSE----------------------------------------------
# weighted <- maihda(outcome ~ age + (1 | gender:race:education),
#                    data = survey_data, sampling_weights = "person_weight")
# weighted

## ----maihda-group, eval=FALSE-------------------------------------------------
# data("maihda_country_data")
# by_country <- maihda(math ~ gender + ses + (1 | gender:ses),
#                      data = maihda_country_data, group = "country")
# by_country
# plot(by_country, type = "group_vpc")

## ----bb-single----------------------------------------------------------------
model_null <- fit_maihda(BMI ~ 1 + (1 | Gender:Race:Education), data = health_complete)
summary(model_null)

## ----bb-custom-pcv------------------------------------------------------------
model_cov <- fit_maihda(BMI ~ Age + Poverty + (1 | Gender:Race:Education),
                        data = health_complete)

calculate_pvc(model_null, model_cov)

## ----bb-pcv-boot, eval=FALSE--------------------------------------------------
# calculate_pvc(model_null, model_cov, bootstrap = TRUE, n_boot = 500)

## ----bb-stepwise--------------------------------------------------------------
stepwise_results <- stepwise_pcv(
  data    = analysis$model$original_data,  # carries the strata column
  outcome = "BMI",
  vars    = c("Age", "Gender", "Race", "Education", "Poverty")
)

print(stepwise_results)

## ----bb-da, eval=FALSE--------------------------------------------------------
# # A binary-outcome analysis
# ob <- maihda(Obese ~ Gender + Race + (1 | Gender:Race), data = maihda_health_data,
#              response_vpc = TRUE, seed = 1)
# ob
# summary(ob)                 # carries the discriminatory_accuracy (+ vpc_response) slots
# 
# # ...or call the pieces directly on the fitted maihda_model objects:
# maihda_discriminatory_accuracy(ob$model)           # AUC + MOR, null model
# maihda_discriminatory_accuracy(ob$model_adjusted)  # adjusted model
# maihda_vpc_response(ob$model, seed = 1)            # probability-scale VPC

## ----bb-group, eval=FALSE-----------------------------------------------------
# data("maihda_country_data")
# compare_maihda_groups(math ~ 1 + (1 | gender:ses),
#                       data = maihda_country_data, group = "country")

## ----eval=FALSE---------------------------------------------------------------
# # Launch the interactive interface
# run_maihda_app()

