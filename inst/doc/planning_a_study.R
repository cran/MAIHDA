## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

## ----lib----------------------------------------------------------------------
library(MAIHDA)
data("maihda_health_data")

## ----strata2------------------------------------------------------------------
s2 <- make_strata(maihda_health_data, vars = c("Gender", "Race"))
nrow(s2$strata_info)                       # number of strata
summary(s2$strata_info$n)              # cell-size distribution

## ----strata3------------------------------------------------------------------
s3 <- make_strata(maihda_health_data, vars = c("Gender", "Race", "Education"))
nrow(s3$strata_info)
summary(s3$strata_info$n)
sum(s3$strata_info$n < 10)             # how many strata have < 10 people

## ----describe-----------------------------------------------------------------
desc <- maihda_describe(BMI ~ Age + (1 | Gender:Race:Education),
                        data = maihda_health_data, flag_stratum_n = 20)
desc

## ----describe-strata----------------------------------------------------------
head(desc$strata[order(desc$strata$n),
                 c("label", "n", "n_analytic", "outcome_mean", "small")])

## ----describe-plot, fig.alt="Histogram of stratum sizes with the small-stratum threshold marked"----
plot(desc, type = "stratum_size")

## ----singular-----------------------------------------------------------------
over <- fit_maihda(
  BMI ~ 1 + (1 | Gender:Race:Education),
  data = maihda_health_data[1:60, ]       # deliberately too few people per stratum
)
over

