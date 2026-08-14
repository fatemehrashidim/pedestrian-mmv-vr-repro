# =============================================================================
# utils.R
# Shared helper functions used across the analysis scripts:
#   - describe()                : descriptive-statistics table
#   - paired_wilcoxon()         : participant-level paired Wilcoxon signed-rank
#   - plot_categorical_effects(): sensitivity plot for categorical predictors
#   - plot_continuous_effects() : sensitivity plot for continuous predictors
# =============================================================================

## ---------------------------------------------------------------------------
## Descriptive statistics (mean, SD and quantiles) for one numeric vector.
## ---------------------------------------------------------------------------
describe <- function(x) {
  x <- x[!is.na(x)]
  q <- quantile(x, c(0, .25, .5, .75, 1))
  data.frame(Mean = mean(x), SD = sd(x),
             Min = q[[1]], Q25 = q[[2]], Median = q[[3]],
             Q75 = q[[4]], Max = q[[5]])
}

## ---------------------------------------------------------------------------
## Participant-level paired Wilcoxon signed-rank test across the two levels of
## a two-level factor. Values are first averaged per participant per level
## (N = number of participants), matching the tables in the paper.
##   use_abs = TRUE reports magnitudes (used where a variable is stored signed).
## ---------------------------------------------------------------------------
paired_wilcoxon <- function(data, outcome, factor_var, use_abs = FALSE) {
  y <- if (use_abs) abs(data[[outcome]]) else data[[outcome]]
  f <- droplevels(as.factor(data[[factor_var]]))
  lv <- levels(f)
  stopifnot(length(lv) == 2)

  agg <- aggregate(y, by = list(participant = data$participant, level = f),
                   FUN = mean, na.rm = TRUE)
  w  <- reshape(agg, idvar = "participant", timevar = "level",
                direction = "wide")
  x1 <- w[[paste0("x.", lv[1])]]
  x2 <- w[[paste0("x.", lv[2])]]
  ok <- stats::complete.cases(x1, x2)

  test <- suppressWarnings(wilcox.test(x1[ok], x2[ok], paired = TRUE))
  data.frame(
    factor = factor_var,
    level  = lv,
    N      = sum(ok),
    mean   = c(mean(x1[ok]), mean(x2[ok])),
    sd     = c(sd(x1[ok]),   sd(x2[ok])),
    W      = unname(test$statistic),
    p      = test$p.value,
    row.names = NULL
  )
}

## ---------------------------------------------------------------------------
## Sensitivity plot for CATEGORICAL predictors of a fitted lmer model.
## Dark bars = 95% CI (emmeans); light bars = 95% prediction interval.
## Set response = TRUE for models fitted on a transformed response (e.g. logTTC).
## ---------------------------------------------------------------------------
plot_categorical_effects <- function(model, vars, facet_labels, ylab,
                                      ylims, ybreaks, outfile, response = FALSE) {
  yvar <- if (response) "response" else "emmean"

  get_one <- function(v) {
    emm <- as.data.frame(emmeans(model, as.formula(paste("~", v)),
                                 type = if (response) "response" else "link"))
    pred <- as.data.frame(suppressMessages(
      ggpredict(model, terms = v, interval = "prediction",
                back.transform = response)))
    emm$variable <- v
    emm$level    <- as.character(emm[[v]])
    idx          <- match(emm$level, as.character(pred$x))
    emm$pi_low   <- pred$conf.low[idx]
    emm$pi_high  <- pred$conf.high[idx]
    emm$y        <- emm[[yvar]]
    emm[, c("variable", "level", "y", "lower.CL", "upper.CL", "pi_low", "pi_high")]
  }

  dat <- purrr::map_dfr(vars, get_one)
  dat$level <- ifelse(dat$level %in% c("scooter", "Scooter"), "E-scooter", dat$level)

  g <- ggplot(dat, aes(x = level, y = y)) +
    geom_errorbar(aes(ymin = pi_low, ymax = pi_high),
                  width = 0.25, linewidth = 1,   colour = "lightblue") +
    geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL),
                  width = 0.12, linewidth = 1.2, colour = "darkblue") +
    geom_point(size = 3, colour = "black") +
    facet_wrap(~ variable, scales = "free_x", nrow = 1,
               labeller = labeller(variable = facet_labels)) +
    labs(x = NULL, y = ylab) +
    scale_y_continuous(limits = ylims, breaks = ybreaks,
                       expand = expansion(mult = c(0, 0.05))) +
    theme_minimal(base_size = 14) +
    theme(strip.text   = element_text(face = "bold", size = 15),
          axis.text.x  = element_text(angle = 30, hjust = 1, size = 13),
          axis.text.y  = element_text(size = 13),
          axis.title.y = element_text(size = 15, margin = margin(r = 12)))

  ggsave(outfile, g, width = 12, height = 4, dpi = 300)
  invisible(g)
}

## ---------------------------------------------------------------------------
## Sensitivity plot for CONTINUOUS predictors of a fitted lmer model.
##   term_labels : named list mapping model term -> facet label
##   xshift      : optional named list adding a constant to the x-axis
##                 (used to display centred predictors on their original scale)
## ---------------------------------------------------------------------------
plot_continuous_effects <- function(model, terms, term_labels, ylab,
                                     ylims, ybreaks, outfile,
                                     xshift = NULL, response = FALSE) {
  sigma_res <- sigma(model)

  get_one <- function(t) {
    pred <- as.data.frame(suppressMessages(
      ggpredict(model, terms = t, back.transform = response)))
    se_mean <- (pred$conf.high - pred$conf.low) / (2 * 1.96)
    if (response) {
      pred$pi_low  <- exp(log(pred$predicted) - 1.96 * sqrt(se_mean^2 + sigma_res^2))
      pred$pi_high <- exp(log(pred$predicted) + 1.96 * sqrt(se_mean^2 + sigma_res^2))
    } else {
      pred$pi_low  <- pred$predicted - 1.96 * sqrt(se_mean^2 + sigma_res^2)
      pred$pi_high <- pred$predicted + 1.96 * sqrt(se_mean^2 + sigma_res^2)
    }
    if (!is.null(xshift) && !is.null(xshift[[t]])) pred$x <- pred$x + xshift[[t]]
    pred$variable <- term_labels[[t]]
    pred[, c("x", "predicted", "conf.low", "conf.high", "pi_low", "pi_high", "variable")]
  }

  dat <- purrr::map_dfr(terms, get_one)

  g <- ggplot(dat, aes(x = x, y = predicted)) +
    geom_ribbon(aes(ymin = pi_low,   ymax = pi_high),   fill = "lightblue", alpha = 0.4) +
    geom_ribbon(aes(ymin = conf.low, ymax = conf.high), fill = "darkblue",  alpha = 0.4) +
    geom_line(colour = "black", linewidth = 1) +
    facet_wrap(~ variable, scales = "free_x", nrow = 1, strip.position = "top") +
    labs(x = NULL, y = ylab) +
    scale_y_continuous(limits = ylims, breaks = ybreaks,
                       expand = expansion(mult = c(0, 0.05))) +
    theme_minimal(base_size = 14) +
    theme(strip.text      = element_text(face = "bold", size = 15),
          strip.background = element_blank(),
          axis.text       = element_text(size = 13),
          axis.title.y    = element_text(size = 15, margin = margin(r = 12)),
          panel.spacing   = unit(1, "lines"))

  ggsave(outfile, g, width = 12, height = 4, dpi = 300)
  invisible(g)
}
