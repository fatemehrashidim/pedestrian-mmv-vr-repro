# =============================================================================
# 00_setup.R
# Loads packages, reads the data, prepares factors and centred predictors.
# Sourced by every analysis script. Run all scripts from the REPOSITORY ROOT.
# =============================================================================

## packages ---------------------------------------------------------------
pkgs <- c("lme4", "lmerTest", "car", "MuMIn", "dplyr",
          "ggeffects", "ggplot2", "emmeans", "purrr")
loaded <- suppressWarnings(sapply(pkgs, requireNamespace, quietly = TRUE))
if (any(!loaded)) {
  stop("Missing packages: ", paste(pkgs[!loaded], collapse = ", "),
       ". Run R/install_packages.R first.")
}
invisible(lapply(pkgs, function(p)
  suppressPackageStartupMessages(library(p, character.only = TRUE))))

## reproducibility --------------------------------------------------------
set.seed(2026)

## output folder for figures ----------------------------------------------
if (!dir.exists("figures")) dir.create("figures")

## data -------------------------------------------------------------------
data_path <- file.path("data", "experiment_data.csv")
df_data <- read.csv(data_path, stringsAsFactors = FALSE)

## factors (reference levels: 0 m, Bike, 1 MMV, density A, Female) ---------
df_data$lateral     <- factor(df_data$lateral,    levels = c(0, 0.6))
df_data$mmv_type    <- factor(df_data$mmv_type,   levels = c("Bike", "Scooter"))
df_data$mmv_number  <- factor(df_data$mmv_number, levels = c(1, 2))
df_data$density     <- factor(df_data$density,    levels = c("A", "B"))
df_data$gender      <- factor(df_data$gender,     levels = c("Female", "Male"))
df_data$age_group   <- factor(df_data$age_group)
df_data$participant <- factor(df_data$participant)

## readable label for e-scooter (matches the paper text and figures)
df_data <- df_data %>% mutate(mmv_type = recode(mmv_type, "Scooter" = "E-scooter"))
df_data$mmv_type <- factor(df_data$mmv_type, levels = c("Bike", "E-scooter"))

## mean-centred continuous predictors used in the models -------------------
df_data$Q3_c         <- df_data$Q3         - mean(df_data$Q3, na.rm = TRUE)   # ExpAcc
df_data$Violations_c <- df_data$Violations - mean(df_data$Violations, na.rm = TRUE)

message("Loaded ", nrow(df_data), " observations from ",
        nlevels(df_data$participant), " participants.")
