## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)
library(MAIHDA)

## ----data---------------------------------------------------------------------
data(maihda_long_data)
head(maihda_long_data)

## ----fit----------------------------------------------------------------------
m <- fit_maihda(wellbeing ~ wave + (1 | gender:ethnicity:education),
                data = maihda_long_data, id = "id", time = "wave")
summary(m)

## ----vpc-traj-----------------------------------------------------------------
plot(m, type = "vpc_trajectory")   # VPC(t), with the reference time marked
plot(m, type = "trajectories")     # predicted per-stratum mean trajectories

## ----traj-vpc-----------------------------------------------------------------
s <- summary(m)
c(intercept = s$longitudinal$vpc_intercept, slope = s$longitudinal$vpc_slope)

## ----traj-vpc-ci, eval = FALSE------------------------------------------------
# s_ci <- summary(m, bootstrap = TRUE, n_boot = 500)
# s_ci$longitudinal$vpc_intercept_ci
# s_ci$longitudinal$vpc_slope_ci

## ----decomp-------------------------------------------------------------------
a <- maihda(wellbeing ~ wave + (1 | gender:ethnicity:education),
            data = maihda_long_data, id = "id", time = "wave",
            decomposition = "longitudinal")
a$pcv

## ----pcv-traj-----------------------------------------------------------------
plot(a, type = "pcv_trajectory")   # the additive share over time

