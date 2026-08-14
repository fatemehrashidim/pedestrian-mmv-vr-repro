# =============================================================================
# 01_descriptives.R
# Reproduces: participant summary (descriptive statistics of the six movement-behaviour indicators).
# =============================================================================
source("R/00_setup.R")
source("R/utils.R")

## participant summary ----------------------------------------------------
pp <- df_data[!duplicated(df_data$participant), ]
cat("\n--- Participant summary ---\n")
cat("N participants :", nrow(pp), "\n")
cat("Gender         :", paste(names(table(pp$gender)), table(pp$gender),
                              collapse = ", "), "\n")
cat(sprintf("Age            : %.2f +/- %.2f (range %d-%d)\n",
            mean(pp$age), sd(pp$age), min(pp$age), max(pp$age)))
cat("N observations :", nrow(df_data), "\n")

## movement-behaviour descriptives -------------------------------
# Deceleration is stored signed; reported here as a magnitude to match the paper.
measures <- list(
  "LatClear (m)"                 = df_data$lateral_clearance,
  "LongDist (m)"                 = df_data$longitudinal_distance,
  "AvgSpd (m/s)"                 = df_data$average_speed,
  "minTTC (s)"                   = df_data$TTC,
  "Max acceleration (m/s^2)"     = df_data$acceleration,
  "Max deceleration (m/s^2)"     = abs(df_data$deceleration)
)

table1 <- do.call(rbind, lapply(measures, describe))
table1 <- round(table1, 2)
cat("\n--- Table 1: Descriptive statistics ---\n")
print(table1)

write.csv(table1, file.path("figures", "table1_descriptives.csv"))
