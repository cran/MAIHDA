## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----load---------------------------------------------------------------------
library(MAIHDA)
data("maihda_health_data")

# A two-level outcome: obese (Yes) vs. not (No)
table(maihda_health_data$Obese)

## ----autodetect---------------------------------------------------------------
model_null <- fit_maihda(
  Obese ~ 1 + (1 | Gender:Race:Education),
  data = maihda_health_data
)

## ----explicit, eval=FALSE-----------------------------------------------------
# model_null <- fit_maihda(
#   Obese ~ 1 + (1 | Gender:Race:Education),
#   data   = maihda_health_data,
#   family = "binomial"
# )

## ----summary-null-------------------------------------------------------------
summary_null <- summary(model_null)
print(summary_null)

## ----vpc-response-------------------------------------------------------------
maihda_vpc_response(model_null, seed = 1)

## ----adjusted-----------------------------------------------------------------
health_complete <- maihda_health_data[complete.cases(
  maihda_health_data[, c("Obese", "Age", "Gender", "Race", "Education")]
), ]

model_null2 <- fit_maihda(
  Obese ~ 1 + (1 | Gender:Race:Education),
  data = health_complete, family = "binomial"
)

# Model 2: adjust for an individual-level covariate (age)
model_adj <- fit_maihda(
  Obese ~ Age + (1 | Gender:Race:Education),
  data = health_complete, family = "binomial"
)

pcv <- calculate_pvc(model_null2, model_adj)
print(pcv)

## ----da-----------------------------------------------------------------------
da_null <- maihda_discriminatory_accuracy(model_null2)
da_adj  <- maihda_discriminatory_accuracy(model_adj)

da_null
da_adj

## ----auc-direct---------------------------------------------------------------
prob_null <- predict_maihda(model_null2, type = "individual", scale = "response")
y_obs     <- as.numeric(lme4::getME(model_null2$model, "y"))

maihda_auc(prob_null, y_obs)

## ----plot-predicted-----------------------------------------------------------
# Predicted probabilities per stratum with intervals
plot(model_adj, type = "predicted")

## ----plot-vpc-----------------------------------------------------------------
# Latent-scale variance partition
plot(model_adj, type = "vpc")

## ----plot-prediction-deviation, warning = FALSE-------------------------------
# For binomial fits the dashboard highlights the largest absolute
# deviance residuals rather than raw deviations from the mean.
plot(model_adj, type = "prediction_deviation")

