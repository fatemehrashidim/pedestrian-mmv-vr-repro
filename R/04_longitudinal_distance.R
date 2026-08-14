# =============================================================================
# 04_longitudinal_distance.R
# Reproduces: Table "longitudinal_wilcoxon".
# The residual-normality assumption of the LMM is violated for longitudinal
# distance, so factor levels are compared with a participant-level paired
# Wilcoxon signed-rank test (values averaged per participant per level).
# =============================================================================
source("R/00_setup.R")
source("R/utils.R")

factors <- c("lateral", "mmv_type", "mmv_number", "density")

res <- do.call(rbind, lapply(
  factors, function(f) paired_wilcoxon(df_data, "longitudinal_distance", f)))
res$mean <- round(res$mean, 2)
res$sd   <- round(res$sd, 2)
res$p    <- signif(res$p, 3)

cat("\n--- Longitudinal distance: paired Wilcoxon signed-rank tests ---\n")
print(res, row.names = FALSE)

write.csv(res, file.path("figures", "table_longitudinal_wilcoxon.csv"),
          row.names = FALSE)
