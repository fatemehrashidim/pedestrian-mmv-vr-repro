# =============================================================================
# 02_subjective_ratings.R
# Reproduces: mean subjective ratings per factor level and the
# Mann-Whitney U tests comparing the two levels of each experimental factor
# for perceived difficulty (Q1), perceived risk (Q2) and expected accidents (Q3).
# =============================================================================
source("R/00_setup.R")
source("R/utils.R")

ratings <- c(PercDiff = "Q1", PercRisk = "Q2", ExpAcc = "Q3")
factors <- c("lateral", "mmv_type", "mmv_number", "density")

results <- list()
for (fac in factors) {
  lv <- levels(df_data[[fac]])
  for (rname in names(ratings)) {
    rv   <- ratings[[rname]]
    form <- as.formula(paste(rv, "~", fac))
    test <- suppressWarnings(wilcox.test(form, data = df_data))
    means <- tapply(df_data[[rv]], df_data[[fac]], mean, na.rm = TRUE)
    results[[length(results) + 1]] <- data.frame(
      Factor  = fac,
      Rating  = rname,
      Level1  = lv[1], Mean1 = round(means[[1]], 2),
      Level2  = lv[2], Mean2 = round(means[[2]], 2),
      U       = unname(test$statistic),
      p       = signif(test$p.value, 3)
    )
  }
}
tab2 <- do.call(rbind, results)
cat("\n--- Table 2: Subjective ratings and Mann-Whitney U tests ---\n")
print(tab2, row.names = FALSE)

write.csv(tab2, file.path("figures", "table2_subjective_ratings.csv"),
          row.names = FALSE)
