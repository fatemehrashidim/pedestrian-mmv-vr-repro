# Pedestrian behaviour during meeting interactions with micro-mobility vehicles in pedestrian streets: a virtual reality experiment


This repository contains the code, an experimental dataset, and
step-by-step instructions to reproduce every table and figure in the paper. It
implements the descriptive statistics, the Mann–Whitney U tests on subjective
ratings, the linear mixed-effects models (lateral clearance, average walking
speed, log minimum TTC), and the participant-level paired Wilcoxon signed-rank
tests (longitudinal distance, maximum acceleration, maximum deceleration).

**Structured Reproducibility Level: SRL 5** (code + data + extensive
documentation + reproducible figures).

---

## Repository structure

```
.
├── README.md                        This file
├── CITATION.cff                     How to cite this repository
├── REPRODUCIBILITY_STATEMENT.md     Statement for the paper + SRL justification
├── data/
│   ├── data_dictionary.md           Definition of every column
│   ├── experiment_data.csv          experimental dataset (875 rows)
├── R/
│   ├── install_packages.R           Installs required CRAN packages
│   ├── 00_setup.R                   Packages, data loading, factor preparation
│   ├── utils.R                      Shared helpers (plots, Wilcoxon, descriptives)
│   ├── 01_descriptives.R            participant summary
│   ├── 02_subjective_ratings.R      Mann–Whitney U tests
│   ├── 03_lateral_clearance.R       LMM + Figures senslateral / continuous_lateral
│   ├── 04_longitudinal_distance.R   Paired Wilcoxon
│   ├── 05_average_speed.R           LMM + Figure sensspeed
│   ├── 06_minTTC.R                  log-LMM + Figures sensTTC / continuous_TTC
│   ├── 07_acceleration.R            Paired Wilcoxon
│   ├── 08_deceleration.R            Paired Wilcoxon
│   ├── run_all.R                    Runs the whole pipeline
│   └── generate_synthetic_data.R    Base-R version of the data generator
└── figures/                         Output folder (figures + result tables)
```

## Requirements

- **R ≥ 4.2** (developed and tested on R 4.x).
- CRAN packages: `lme4`, `lmerTest`, `car`, `MuMIn`, `dplyr`, `ggeffects`,
  `ggplot2`, `emmeans`, `purrr`.

## How to reproduce the results

From the **repository root**:

```r
# 1. Install dependencies (once)
Rscript R/install_packages.R

# 2. Run the full pipeline
Rscript R/run_all.R
```

Or, inside an R session started at the repository root:

```r
source("R/run_all.R")
```

You can also run any single analysis, e.g. `source("R/03_lateral_clearance.R")`.
Each script sources `R/00_setup.R` and `R/utils.R` automatically.

**Outputs.** Tables are printed to the console and also written as CSV files to
`figures/`; all figures are written to `figures/`.

## What each script reproduces

| Script | Paper element |
|---|---|
| `01_descriptives.R` | Participant summary; Table 1 (descriptive statistics) |
| `02_subjective_ratings.R` | Table 2 (subjective ratings; Mann–Whitney U tests) |
| `03_lateral_clearance.R` | Lateral-clearance LMM tables; `senslateral.png`, `continuous_lateral.png` |
| `04_longitudinal_distance.R` | Longitudinal-distance Wilcoxon table |
| `05_average_speed.R` | Average-speed LMM tables; `sensspeed.png` |
| `06_minTTC.R` | log(minTTC) LMM tables; `sensTTC.png`, `continuous_TTC.png` |
| `07_acceleration.R` | Maximum-acceleration Wilcoxon table |
| `08_deceleration.R` | Maximum-deceleration Wilcoxon table |

## Notes on the modelling choices (as in the paper)

- Models are fitted with **REML** using `lme4::lmer`, with a random intercept
  for participant to account for repeated measures.
- Model selection followed the paper: candidate models compared by BIC, retained
  effects verified at the 5% level.
- Where the residual-normality assumption of the LMM was violated
  (longitudinal distance, acceleration, deceleration), factor levels are
  compared with a **participant-level paired Wilcoxon signed-rank test**
  (values averaged per participant per level; N = 30).
- `minTTC` is modelled on the **log** scale; predictions are back-transformed to
  seconds for the figures.
- Continuous predictors (`ExpAcc`, `Violations`) are **mean-centred** before
  modelling.



## Contact

Please open an issue in this repository, or contact the corresponding author
(Fatemeh Rashidi) for questions about reproduction or data access.
