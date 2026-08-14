# =============================================================================
# 05_average_speed.R
# Reproduces: linear mixed-effects model for average walking speed
# (Tables "speed-stats" / "speed_model" and Figure sensspeed.png).
# =============================================================================
source("R/00_setup.R")
source("R/utils.R")

## model ------------------------------------------------------------------
m_spd <- lmer(
  average_speed ~ lateral + mmv_type + mmv_number + density + (1 | participant),
  data = df_data, REML = TRUE
)
cat("\n--- Average speed: fixed effects ---\n")
print(summary(m_spd)$coefficients)

print(VarCorr(m_spd))
## diagnostics ------------------------------------------------------------
cat("\nVIF:\n");            print(vif(m_spd))
cat("\nResidual normality (Shapiro-Wilk):\n")
print(shapiro.test(resid(m_spd)))
cat("\nRandom-intercept normality (Shapiro-Wilk):\n")
print(shapiro.test(ranef(m_spd)$participant[, 1]))

cat("\nR-squared (marginal / conditional):\n")
print(r.squaredGLMM(m_spd))

m_null <- lmer(average_speed ~ 1 + (1 | participant),
               data = df_data, REML = TRUE)
cat("\nLikelihood-ratio test vs null model:\n")
print(anova(m_null, m_spd))

## sensitivity plot -------------------------------------------------------
facet_labels <- c(lateral = "Lateral Position", mmv_type = "MMV Type",
                  mmv_number = "MMV Number", density = "Density")

plot_categorical_effects(
  model = m_spd,
  vars  = c("lateral", "mmv_type", "mmv_number", "density"),
  facet_labels = facet_labels,
  ylab   = "Predicted Average Speed (m/s)",
  ylims  = c(0.7, 1.5), ybreaks = seq(0.7, 1.5, 0.2),
  outfile = file.path("figures", "sensspeed.png")
)

cat("\nFigure written to figures/sensspeed.png\n")
