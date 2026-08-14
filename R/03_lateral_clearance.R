# =============================================================================
# 03_lateral_clearance.R
# Reproduces: linear mixed-effects model for lateral clearance
# ("lateral-stats" / "lateralclearance_model" and Figures
# senslateral.png / continuous_lateral.png).
# =============================================================================
source("R/00_setup.R")
source("R/utils.R")

## model ------------------------------------------------------------------
m_lat <- lmer(
  lateral_clearance ~ lateral + mmv_type + mmv_number +
    Q3_c + gender + Violations_c + (1 | participant),
  data = df_data, REML = TRUE
)
cat("\n--- Lateral clearance: fixed effects ---\n")
print(summary(m_lat)$coefficients)

print(VarCorr(m_lat))

## diagnostics ------------------------------------------------------------
cat("\nVIF:\n");            print(vif(m_lat))
cat("\nResidual normality (Shapiro-Wilk):\n")
print(shapiro.test(resid(m_lat)))
cat("\nRandom-intercept normality (Shapiro-Wilk):\n")
print(shapiro.test(ranef(m_lat)$participant[, 1]))

cat("\nR-squared (marginal / conditional):\n")
print(r.squaredGLMM(m_lat))

m_null <- lmer(lateral_clearance ~ 1 + (1 | participant),
               data = df_data, REML = TRUE)
cat("\nLikelihood-ratio test vs null model:\n")
print(anova(m_null, m_lat))

## sensitivity plots ------------------------------------------------------
facet_labels <- c(lateral = "Lateral Position", mmv_type = "MMV Type",
                  mmv_number = "MMV Number", gender = "Gender")

plot_categorical_effects(
  model = m_lat,
  vars  = c("lateral", "mmv_type", "mmv_number", "gender"),
  facet_labels = facet_labels,
  ylab   = "Predicted Lateral Clearance (m)",
  ylims  = c(0.5, 1.5), ybreaks = seq(0.5, 1.5, 0.2),
  outfile = file.path("figures", "senslateral.png")
)

plot_continuous_effects(
  model = m_lat,
  terms = c("Q3_c", "Violations_c"),
  term_labels = list(Q3_c = "ExpAcc", Violations_c = "Violations"),
  xshift = list(Q3_c = mean(df_data$Q3), Violations_c = mean(df_data$Violations)),
  ylab   = "Predicted Lateral Clearance (m)",
  ylims  = c(0.5, 1.5), ybreaks = seq(0.5, 1.5, 0.2),
  outfile = file.path("figures", "continuous_lateral.png")
)

cat("\nFigures written to figures/senslateral.png and continuous_lateral.png\n")
