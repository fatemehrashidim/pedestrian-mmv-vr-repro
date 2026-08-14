# =============================================================================
# install_packages.R
# Installs the CRAN packages required to run the analysis pipeline.
# Run once from the repository ROOT:  Rscript R/install_packages.R
# =============================================================================
required <- c(
  "lme4",       # linear mixed-effects models
  "lmerTest",   # p-values for lmer fixed effects
  "car",        # variance inflation factors (vif)
  "MuMIn",      # marginal / conditional R-squared
  "dplyr",      # data manipulation
  "ggeffects",  # marginal predictions and prediction intervals
  "ggplot2",    # figures
  "emmeans",    # estimated marginal means
  "purrr"       # functional iteration
)

to_install <- required[!(required %in% rownames(installed.packages()))]
if (length(to_install)) {
  install.packages(to_install, repos = "https://cloud.r-project.org")
} else {
  message("All required packages are already installed.")
}
