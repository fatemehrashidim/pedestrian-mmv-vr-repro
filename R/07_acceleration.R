# =============================================================================
# 07_acceleration.R
# Reproduces: Table "acceleration_wilcoxon".
# The LMM residual-normality assumption is violated for maximum acceleration,
# so factor levels are compared with a participant-level paired Wilcoxon test.
# =============================================================================
source("R/00_setup.R")
source("R/utils.R")

factors <- c("lateral", "mmv_type", "mmv_number", "density")

res <- do.call(rbind, lapply(
  factors, function(f) paired_wilcoxon(df_data, "acceleration", f)))
res$mean <- round(res$mean, 3)
res$sd   <- round(res$sd, 3)
res$p    <- signif(res$p, 3)

cat("\n--- Maximum acceleration: paired Wilcoxon signed-rank tests ---\n")
print(res, row.names = FALSE)

write.csv(res, file.path("figures", "table_acceleration_wilcoxon.csv"),
          row.names = FALSE)
