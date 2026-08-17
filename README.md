# Pedestrian behaviour when interacting with micro-mobility vehicles: a virtual reality experiment

This repository contains the code, the experimental dataset, and step-by-step
instructions to reproduce every table and figure in the paper. It implements the
descriptive statistics, the Mann–Whitney U tests on subjective ratings, the
linear mixed-effects models (lateral clearance, average walking speed, log
minimum TTC), and the participant-level paired Wilcoxon signed-rank tests
(longitudinal distance, maximum acceleration, maximum deceleration).


---

## Repository structure

```
.
├── README.md                        This file
├── LICENSE                          Licensing (MIT)
├── CITATION.cff                     How to cite this repository
├── .gitignore
├── data/
│   ├── data_dictionary.md           Definition of every column
│   └── experiment_data.csv          Experimental dataset (875 rows)
├── R/
│   ├── install_packages.R           Installs required CRAN packages
│   ├── 00_setup.R                   Packages, data loading, factor preparation
│   ├── utils.R                      Shared helpers (plots, Wilcoxon, descriptives)
│   ├── 01_descriptives.R            Participant summary; descriptive statistics
│   ├── 02_subjective_ratings.R      Mann–Whitney U tests
│   ├── 03_lateral_clearance.R       LMM + Figures senslateral / continuous_lateral
│   ├── 04_longitudinal_distance.R   Paired Wilcoxon
│   ├── 05_average_speed.R           LMM + Figure sensspeed
│   ├── 06_minTTC.R                  log-LMM + Figures sensTTC / continuous_TTC
│   ├── 07_acceleration.R            Paired Wilcoxon
│   ├── 08_deceleration.R            Paired Wilcoxon
│   └── run_all.R                    Runs the whole pipeline
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
| `01_descriptives.R` | Participant summary; descriptive statistics |
| `02_subjective_ratings.R` | subjective ratings; Mann–Whitney U tests |
| `03_lateral_clearance.R` | Lateral-clearance LMM tables; `senslateral.png`, `continuous_lateral.png` |
| `04_longitudinal_distance.R` | Longitudinal-distance Wilcoxon table |
| `05_average_speed.R` | Average-speed LMM tables; `sensspeed.png` |
| `06_minTTC.R` | log(minTTC) LMM tables; `sensTTC.png`, `continuous_TTC.png` |
| `07_acceleration.R` | Maximum-acceleration Wilcoxon table |
| `08_deceleration.R` | Maximum-deceleration Wilcoxon table |



## Contact

Please open an issue in this repository, or contact the corresponding author
(Fatemeh Rashidi) for questions about reproduction or data access.
