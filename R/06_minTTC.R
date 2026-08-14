# =============================================================================
# 06_minTTC.R
# Reproduces: linear mixed-effects model for the logarithm of minimum
# Time-to-Collision (Tables "TTC-stats" / "ttc_model" and Figures
# sensTTC.png / continuous_TTC.png).
# =============================================================================
source("R/00_setup.R")
source("R/utils.R")

##  model (log-transformed response) ---------------------------------------
m_ttc <- lmer(
  log(TTC) ~ lateral + mmv_type + mmv_number + density +
    gender + Q3_c + (1 | participant),
  data = df_data, REML = TRUE
)
cat("\n--- log(minTTC): fixed effects ---\n")
print(summary(m_ttc)$coefficients)

print(VarCorr(m_ttc))

##  diagnostics ------------------------------------------------------------
cat("\nVIF:\n");            print(vif(m_ttc))
cat("\nResidual normality (Shapiro-Wilk):\n")
print(shapiro.test(resid(m_ttc)))
cat("\nRandom-intercept normality (Shapiro-Wilk):\n")
print(shapiro.test(ranef(m_ttc)$participant[, 1]))

cat("\nR-squared (marginal / conditional):\n")
print(r.squaredGLMM(m_ttc))

m_null <- lmer(log(TTC) ~ 1 + (1 | participant),
               data = df_data, REML = TRUE)
cat("\nLikelihood-ratio test vs null model:\n")
print(anova(m_null, m_ttc))

##  sensitivity plots (back-transformed to seconds) ------------------------
facet_labels <- c(lateral = "Lateral Position", mmv_type = "MMV Type",
                  mmv_number = "MMV Number", density = "Density",
                  gender = "Gender")

plot_categorical_effects(
  model = m_ttc,
  vars  = c("lateral", "mmv_type", "mmv_number", "density", "gender"),
  facet_labels = facet_labels,
  ylab   = "Predicted Minimum TTC (s)",
  ylims  = c(0.2, 0.45), ybreaks = seq(0.2, 0.45, 0.05),
  outfile = file.path("figures", "sensTTC.png"),
  response = TRUE
)

plot_continuous_effects(
  model = m_ttc,
  terms = c("Q3_c"),
  term_labels = list(Q3_c = "ExpAcc"),
  xshift = list(Q3_c = mean(df_data$Q3)),
  ylab   = "Predicted Minimum TTC (s)",
  ylims  = c(0.2, 0.45), ybreaks = seq(0.2, 0.45, 0.05),
  outfile = file.path("figures", "continuous_TTC.png"),
  response = TRUE
)

cat("\nFigures written to figures/sensTTC.png and continuous_TTC.png\n")

print(VarCorr(m_ttc))
