## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.2,
  warning = FALSE,
  message = FALSE
)
library(MAIHDA)
library(ggplot2)
# brms needs Stan and a compiler and takes minutes, so it cannot run on CRAN's or
# pkgdown's builders. Its results are precomputed in data-raw/precompute_sparse_vignette.R
# and read from a small cache here; the fast lme4 fits run live.
pc <- readRDS("sparse_precomputed.rds")
pct <- function(x) sprintf("%.0f%%", 100 * x)

## ----data---------------------------------------------------------------------
data(maihda_sparse_data)
d <- maihda_sparse_data

cells <- table(interaction(d$gender, d$ethnicity, d$education, d$age_group, drop = TRUE))
summary(as.numeric(cells))                    # cell-size distribution
sum(cells < 5)                                # how many strata have < 5 people
attr(d, "truth")$gaussian$interaction_share   # the true interaction share: 0.40

## ----lme4---------------------------------------------------------------------
m_g <- maihda(y ~ 1 + (1 | gender:ethnicity:education:age_group),
              data = d, decomposition = "crossed-dimensions", engine = "lme4")
m_b <- maihda(event ~ 1 + (1 | gender:ethnicity:education:age_group),
              data = d, decomposition = "crossed-dimensions",
              engine = "lme4", family = "binomial")

c(gaussian = m_g$decomposition$interaction_share,
  binary   = m_b$decomposition$interaction_share)
c(gaussian_singular = isTRUE(m_g$model$diagnostics$singular),
  binary_singular   = isTRUE(m_b$model$diagnostics$singular))

## ----brms-call, eval = FALSE--------------------------------------------------
# m_g_brms <- maihda(
#   y ~ 1 + (1 | gender:ethnicity:education:age_group),
#   data = d, decomposition = "crossed-dimensions", engine = "brms",
#   prior = brms::set_prior("normal(0, 0.5)", class = "sd"),
#   chains = 4, iter = 2000, warmup = 1000, cores = 4, seed = 1,
#   control = list(adapt_delta = 0.97)
# )
# m_g_brms$decomposition$interaction_share
# m_g_brms$decomposition$interaction_share_ci

## ----brms-summary-------------------------------------------------------------
bg <- pc$brms$gaussian; bb <- pc$brms$binary
data.frame(
  outcome      = c("Gaussian", "Binary"),
  true_share   = c(pc$truth$gaussian$interaction_share, pc$truth$binary_latent$interaction_share),
  brms_share   = c(bg$share, bb$share),
  ci_low       = c(bg$ci[1], bb$ci[1]),
  ci_high      = c(bg$ci[2], bb$ci[2]),
  max_rhat     = c(bg$diag$max_rhat, bb$diag$max_rhat),
  divergences  = c(bg$diag$divergences, bb$diag$divergences)
)

## ----fig-share, fig.height = 3.8----------------------------------------------
fig <- data.frame(
  outcome = factor(rep(c("Gaussian", "Binary"), each = 2), levels = c("Gaussian", "Binary")),
  method  = rep(c("lme4 (ML)", "brms (Bayesian)"), 2),
  share   = c(pc$lme4$gaussian$share, pc$brms$gaussian$share,
              pc$lme4$binary$share,   pc$brms$binary$share),
  lo      = c(NA, pc$brms$gaussian$ci[1], NA, pc$brms$binary$ci[1]),
  hi      = c(NA, pc$brms$gaussian$ci[2], NA, pc$brms$binary$ci[2])
)
truth <- pc$truth$gaussian$interaction_share

ggplot(fig, aes(method, share, colour = method)) +
  geom_hline(yintercept = truth, linetype = "dashed") +
  geom_pointrange(aes(ymin = lo, ymax = hi), na.rm = TRUE, linewidth = 0.8) +
  geom_point(size = 2.5) +
  facet_wrap(~ outcome) +
  scale_y_continuous("Interaction share of between-stratum variance",
                     labels = function(x) paste0(round(100 * x), "%")) +
  labs(x = NULL, colour = NULL,
       title = "A singular ML point estimate vs. a brms posterior interval",
       subtitle = "Dashed line: true interaction share (40%)") +
  theme_minimal() + theme(legend.position = "none")

