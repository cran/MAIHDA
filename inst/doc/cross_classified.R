## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----fit----------------------------------------------------------------------
library(MAIHDA)
data("maihda_health_data")

cc <- maihda(
  BMI ~ Age + (1 | Gender:Race:Education),
  data = maihda_health_data,
  decomposition = "crossed-dimensions"
)
cc

## ----formula------------------------------------------------------------------
cc$formula

## ----decomposition------------------------------------------------------------
cc$decomposition$additive_var        # sum of the dimension random-effect variances
cc$decomposition$interaction_var     # the intersection random-effect variance
cc$decomposition$additive_share      # additive share of the between-strata variance
cc$decomposition$interaction_share   # the complement: the interaction share
cc$decomposition$per_dim             # additive variance per dimension

## ----summary------------------------------------------------------------------
summary(cc$model)

## ----plots--------------------------------------------------------------------
plot(cc, type = "vpc")            # per-dimension additive + interaction + residual
plot(cc, type = "effect_decomp")  # additive vs. interaction, per stratum

## ----plots-ternary, eval = requireNamespace("ggtern", quietly = TRUE), warning = FALSE, message = FALSE----
plot(cc, type = "ternary")        # additive / interaction / uncertainty per stratum

## ----groups, eval = FALSE-----------------------------------------------------
# data("maihda_country_data")
# cc_grp <- maihda(
#   math ~ 1 + (1 | gender:ses),
#   data = maihda_country_data,
#   group = "country",
#   decomposition = "crossed-dimensions"
# )
# plot(cc_grp, type = "group_additive_share")  # additive share by country
# plot(cc_grp, type = "group_components")       # additive / interaction / residual

## ----brms, eval = FALSE-------------------------------------------------------
# cc_b <- maihda(
#   BMI ~ Age + (1 | Gender:Race:Education),
#   data = maihda_health_data,
#   engine = "brms",
#   decomposition = "crossed-dimensions"
# )
# cc_b$decomposition$additive_share_ci

## ----context-fit--------------------------------------------------------------
data("maihda_country_data")

ctx <- fit_maihda(
  math ~ 1 + (1 | gender:ses),
  data = maihda_country_data,
  context = "country"
)
summary(ctx)

## ----context-compare----------------------------------------------------------
# Strata-only fit for comparison: its VPC may partly reflect country clustering.
m0 <- fit_maihda(math ~ 1 + (1 | gender:ses), data = maihda_country_data)
summary(m0)$vpc$estimate          # strata-only VPC
s <- summary(ctx)
s$vpc$estimate                    # between-stratum share conditional on country
s$context$vpc_context_total      # the country (general contextual) share

## ----context-maihda-----------------------------------------------------------
a <- maihda(
  math ~ 1 + (1 | gender:ses),
  data = maihda_country_data,
  context = "country"
)
a

## ----context-plot-------------------------------------------------------------
plot(a, type = "vpc")          # stacked shares, with the context broken out
plot(a, type = "context_vpc")  # stratum vs. context variances side by side

