# =============================================================================
# run_all.R
# Runs the full analysis pipeline end to end. Execute from the repository ROOT:
#   Rscript R/run_all.R
# Console output reproduces the tables; figures are written to figures/.
# =============================================================================
scripts <- c(
  "R/01_descriptives.R",
  "R/02_subjective_ratings.R",
  "R/03_lateral_clearance.R",
  "R/04_longitudinal_distance.R",
  "R/05_average_speed.R",
  "R/06_minTTC.R",
  "R/07_acceleration.R",
  "R/08_deceleration.R"
)

for (s in scripts) {
  cat("\n\n=====================================================\n")
  cat("Running", s, "\n")
  cat("=====================================================\n")
  source(s, echo = FALSE)
}

cat("\n\nAll analyses complete. See console output above and the figures/ folder.\n")
