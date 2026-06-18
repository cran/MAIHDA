## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----model--------------------------------------------------------------------
library(MAIHDA)
data("maihda_health_data")

health_complete <- maihda_health_data[complete.cases(
  maihda_health_data[, c("BMI", "Age", "Gender", "Race", "Education")]
), ]

model <- maihda(
  BMI ~ Age + Gender + Race + Education + (1 | Gender:Race:Education),
  data = health_complete
)
# or equivalently with the helper:
# model <- fit_maihda(
#   BMI ~ Age + Gender + Race + Education + (1 | Gender:Race:Education),
#   data = health_complete
# )

## ----vpc----------------------------------------------------------------------
plot(model, type = "vpc")

## ----predicted----------------------------------------------------------------
plot(model, type = "predicted")

## ----obs-shrunken-------------------------------------------------------------
plot(model, type = "obs_vs_shrunken")

## ----effect-decomp------------------------------------------------------------
plot(model, type = "effect_decomp")

## ----ternary, eval = requireNamespace("ggtern", quietly = TRUE), warning = FALSE, message = FALSE----
plot(model, type = "ternary")

## ----prediction-deviation-----------------------------------------------------
plot(model, type = "prediction_deviation")

## ----customize-theme----------------------------------------------------------
library(ggplot2)

plot(model, type = "vpc") +
  theme_classic(base_size = 13) +
  labs(title = "Variance partition, restyled")

## ----customize-palette, message = FALSE---------------------------------------
plot(model, type = "vpc") +
  scale_fill_brewer(palette = "Set2")

## ----customize-patchwork, warning = FALSE-------------------------------------
plot(model, type = "prediction_deviation") & theme_minimal()

## ----customize-all, eval = FALSE----------------------------------------------
# plots <- plot(model)          # list: vpc, predicted, effect_decomp, ...
# plots$predicted + theme_bw()

