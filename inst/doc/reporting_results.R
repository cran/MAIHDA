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

a <- maihda(
  BMI ~ Age + Gender + Race + Education + (1 | Gender:Race:Education),
  data = maihda_health_data
)

## ----glance-------------------------------------------------------------------
glance(a)

## ----tidy-strata--------------------------------------------------------------
strata <- tidy(a, component = "strata")
head(strata)

## ----tidy-variance------------------------------------------------------------
tidy(a, component = "variance")

## ----tidy-fixed---------------------------------------------------------------
tidy(a, component = "fixed", which = "adjusted")

## ----tidy-plot, fig.height = 5------------------------------------------------
library(ggplot2)

strata_ord <- strata[order(strata$estimate), ]
strata_ord$label <- factor(strata_ord$label, levels = strata_ord$label)

ggplot(strata_ord, aes(x = estimate, y = label)) +
  geom_vline(xintercept = 0, linetype = "dashed", colour = "grey60") +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  labs(x = "Stratum random effect (BLUP)", y = NULL,
       title = "Intersectional strata, ordered by estimated deviation") +
  theme_minimal()

## ----table-print--------------------------------------------------------------
tab <- maihda_table(a)
tab

## ----table-models-------------------------------------------------------------
knitr::kable(tab$models, digits = 3,
             caption = "MAIHDA model-results table (null vs. adjusted).")

## ----table-csv, eval = FALSE--------------------------------------------------
# write.csv(tab$models, "maihda_results.csv", row.names = FALSE)

## ----table-strata-------------------------------------------------------------
head(tab$strata)

## ----table-gt, eval = requireNamespace("gt", quietly = TRUE)------------------
# gt::gt(tab$models)

## ----ic-----------------------------------------------------------------------
maihda_ic(a)

