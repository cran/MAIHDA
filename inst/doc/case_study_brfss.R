## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 4.5
)

# This is an UNWEIGHTED MAIHDA on the full ~352,714-record complete-case sample. An
# lme4 glmer on that many rows (with the 432-group random intercept, two models)
# takes minutes -- too slow for a package build -- so it is fitted once by
# data-raw/brfss_precompute.R and this article renders from a small cache plus
# pre-rendered figures.
pc <- readRDS("brfss_precomputed.rds")

fmt  <- function(x, d = 3) formatC(as.numeric(x), format = "f", digits = d)
fmt0 <- function(x, d = 3) ifelse(is.na(x), "", formatC(as.numeric(x), format = "f", digits = d))
pct  <- function(x, d = 1) paste0(formatC(100 * as.numeric(x), format = "f", digits = d), "%")
big  <- function(x) format(as.numeric(x), big.mark = ",", trim = TRUE)

## ----download, eval = FALSE---------------------------------------------------
# library(MAIHDA)
# library(dplyr)
# 
# raw_cols <- c(
#   "_MENT14D", "SEXVAR", "_IMPRACE", "_AGEG5YR", "EDUCA", "_INCOMG1",
#   "DEAF", "BLIND", "DECIDE", "DIFFWALK", "DIFFDRES", "DIFFALON"
# )
# 
# brfss_raw <- haven::read_xpt(xpt_file, col_select = dplyr::all_of(raw_cols))
# dim(brfss_raw)

## ----recode, eval = FALSE-----------------------------------------------------
# disability_vars <- c("DEAF", "BLIND", "DECIDE", "DIFFWALK", "DIFFDRES", "DIFFALON")
# disability_items <- brfss_raw[disability_vars]
# 
# any_disability <- rowSums(disability_items == 1, na.rm = TRUE) > 0
# all_answered_no <- rowSums(disability_items == 2, na.rm = TRUE) == length(disability_vars)
# 
# brfss_reduced <- brfss_raw |>
#   transmute(
#     frequent_distress = case_when(
#       .data[["_MENT14D"]] == 3 ~ 1L,
#       .data[["_MENT14D"]] %in% c(1, 2) ~ 0L,
#       TRUE ~ NA_integer_
#     ),
#     sex = factor(
#       case_when(SEXVAR == 1 ~ "Male", SEXVAR == 2 ~ "Female", TRUE ~ NA_character_),
#       levels = c("Male", "Female")
#     ),
#     race_ethnicity = factor(
#       case_when(
#         .data[["_IMPRACE"]] == 1 ~ "White, non-Hispanic",
#         .data[["_IMPRACE"]] == 2 ~ "Black, non-Hispanic",
#         .data[["_IMPRACE"]] == 5 ~ "Hispanic",
#         .data[["_IMPRACE"]] %in% c(3, 4, 6) ~ "Other race/ethnicity",
#         TRUE ~ NA_character_
#       ),
#       levels = c("White, non-Hispanic", "Black, non-Hispanic",
#                  "Hispanic", "Other race/ethnicity")
#     ),
#     age_group = factor(
#       case_when(
#         .data[["_AGEG5YR"]] %in% 1:3 ~ "18-34",
#         .data[["_AGEG5YR"]] %in% 4:9 ~ "35-64",
#         .data[["_AGEG5YR"]] %in% 10:13 ~ "65+",
#         TRUE ~ NA_character_
#       ),
#       levels = c("18-34", "35-64", "65+")
#     ),
#     education = factor(
#       case_when(
#         EDUCA %in% 1:4 ~ "HS or less", EDUCA == 5 ~ "Some college",
#         EDUCA == 6 ~ "College graduate", TRUE ~ NA_character_
#       ),
#       levels = c("HS or less", "Some college", "College graduate")
#     ),
#     income = factor(
#       case_when(
#         .data[["_INCOMG1"]] %in% 1:2 ~ "<$25k",
#         .data[["_INCOMG1"]] %in% 3:4 ~ "$25k-<$50k",
#         .data[["_INCOMG1"]] %in% 5:7 ~ "$50k+",
#         TRUE ~ NA_character_
#       ),
#       levels = c("<$25k", "$25k-<$50k", "$50k+")
#     ),
#     disability = factor(
#       case_when(
#         any_disability ~ "Any disability", all_answered_no ~ "No disability",
#         TRUE ~ NA_character_
#       ),
#       levels = c("No disability", "Any disability")
#     )
#   ) |>
#   filter(
#     !is.na(frequent_distress), !is.na(sex), !is.na(race_ethnicity),
#     !is.na(age_group), !is.na(education), !is.na(income), !is.na(disability)
#   )

## ----fit-code, eval = FALSE---------------------------------------------------
# brfss_fit <- maihda(
#   frequent_distress ~ sex + race_ethnicity + age_group + education + income + disability +
#     (1 | sex:race_ethnicity:age_group:education:income:disability),
#   data = brfss_reduced, family = "binomial", interactions = "BH"
# )
# 
# brfss_fit
# generics::glance(brfss_fit)

## ----model-table, echo = FALSE------------------------------------------------
mt <- pc$model_table
knitr::kable(
  data.frame(
    Statistic            = mt$statistic,
    `Null (Model 1)`     = fmt0(mt$null),
    `Adjusted (Model 2)` = fmt0(mt$adjusted),
    check.names = FALSE
  ),
  caption = "Model-results table."
)

## ----ranked-strata-cached, echo = FALSE---------------------------------------
ts <- pc$top_strata
disp <- data.frame(Rank = ts$rank, Stratum = ts$label, Predicted = fmt(ts$predicted),
                   check.names = FALSE)
if ("observed" %in% names(ts)) disp[["Observed"]] <- fmt(ts$observed)
if ("raw_n" %in% names(ts)) disp[["N"]] <- big(ts$raw_n)
knitr::kable(disp, caption = "Highest predicted-risk strata.")

## ----interaction-table-cached, echo = FALSE-----------------------------------
it <- pc$top_interactions
disp <- data.frame(Stratum = it$label, Interaction = fmt(it$interaction),
                   Lower = fmt(it$lower), Upper = fmt(it$upper), check.names = FALSE)
if ("direction" %in% names(it)) disp[["Direction"]] <- it$direction
if ("decision" %in% names(it)) disp[["ROPE (±0.4)"]] <- it$decision
knitr::kable(head(disp, 15), digits = 3,
             caption = "Strongest interactions by absolute size, with ROPE classification.")

## ----rope-code, eval = FALSE--------------------------------------------------
# maihda_interactions(brfss_fit, rope = 0.4)   # ROPE = +/- 0.4 log-odds (OR ~ 1.5)

## ----plot-vpc-cached, echo = FALSE, out.width = "100%", fig.cap = "Variance partition (VPC): share of latent-scale variation between intersectional strata."----
knitr::include_graphics("figures/brfss_vpc.png")

## ----plot-code, eval = FALSE--------------------------------------------------
# plot(brfss_fit, type = "upset", n_strata = 20, select = "deviation",
#      highlight_interactions = TRUE, highlight_by = "rope", rope = 0.4)
# plot(brfss_fit, type = "effect_decomp",
#      highlight_interactions = TRUE, highlight_by = "rope", rope = 0.4)

## ----plot-upset-cached, echo = FALSE, out.width = "100%", fig.cap = "UpSet-style predicted-risk view: read each stratum's defining category off the matrix instead of a long text label. Columns are the most extreme-risk strata plus the ROPE-relevant ones (±0.4), which are highlighted."----
knitr::include_graphics("figures/brfss_upset.png")

## ----plot-effect-cached, echo = FALSE, out.width = "100%", fig.cap = "Effect decomposition: additive (fixed-effect) vs. residual stratum (interaction) component per stratum; the two ROPE-relevant strata (±0.4) are labelled."----
knitr::include_graphics("figures/brfss_effect_decomp.png")

