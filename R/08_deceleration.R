# =============================================================================
# 08_deceleration.R
# Reproduces: Table "deceleration_wilcoxon".
# Maximum deceleration is stored as a signed (negative) value; the paired
# Wilcoxon test is applied to the signed values (as in the paper), so reported
# means are negative and more negative values indicate stronger deceleration.
# =============================================================================
source("R/00_setup.R")
source("R/utils.R")

factors <- c("lateral", "mmv_type", "mmv_number", "density")

res <- do.call(rbind, lapply(
  factors, function(f) paired_wilcoxon(df_data, "deceleration", f)))
res$mean <- round(res$mean, 3)
res$sd   <- round(res$sd, 3)
res$p    <- signif(res$p, 3)

cat("\n--- Maximum deceleration: paired Wilcoxon signed-rank tests ---\n")
print(res, row.names = FALSE)

write.csv(res, file.path("figures", "table_deceleration_wilcoxon.csv"),
          row.names = FALSE)
