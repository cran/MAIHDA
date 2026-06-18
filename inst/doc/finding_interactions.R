## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----model-bh-----------------------------------------------------------------
library(MAIHDA)
model_bh <- maihda(
  BMI ~ Age + Gender + Race + Education + (1 | Gender:Race:Education),
  data = maihda_health_data,
  interactions = "BH" # Benjamini-Hochberg adjustment
)

## ----table--------------------------------------------------------------------
model_bh$interactions

## ----plot-decomp, fig.height = 5----------------------------------------------
plot(model_bh, type = "effect_decomp", highlight_interactions = TRUE)

## ----plot-predicted, fig.height = 5-------------------------------------------
plot(model_bh, type = "predicted", highlight_interactions = TRUE)

## ----plot-bh-shorthand, eval = FALSE------------------------------------------
# plot(model, type = "effect_decomp", highlight_interactions = "BH")

