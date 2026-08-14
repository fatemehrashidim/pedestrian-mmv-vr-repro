# Data dictionary


## Identifiers and design factors

| Column | Type | Values | Description |
|---|---|---|---|
| `participant` | string | `P01`–`P30` | Participant identifier |
| `scenario` | integer | 1–16 | Scenario id in the 2×2×2×2 full-factorial design |
| `lateral` | numeric factor | `0.0`, `0.6` | Initial lateral position of the (first) MMV, in metres. Reference: `0.0` |
| `mmv_type` | factor | `Bike`, `Scooter` | MMV type. Recoded to `E-scooter` in analysis. Reference: `Bike` |
| `mmv_number` | factor | `1`, `2` | Number of simultaneously approaching MMVs. Reference: `1` |
| `density` | factor | `A`, `B` | Pedestrian level of service (HCM). Reference: `A` |

## Participant characteristics (constant within a participant)

| Column | Type | Values | Description |
|---|---|---|---|
| `gender` | factor | `Female`, `Male` | Self-reported gender. Reference: `Female` |
| `age` | integer | 20–62 | Age in years |
| `age_group` | factor | `20-30`, `31-45`, `46-65` | Age band |
| `vr_experience` | factor | `Yes`, `No` | Prior experience with a VR headset |
| `Violations` | numeric | 1–5 | Pedestrian Behaviour Questionnaire (PBQ) subscale |
| `Errors` | numeric | 1–5 | PBQ subscale |
| `Lapses` | numeric | 1–5 | PBQ subscale |
| `Aggressive` | numeric | 1–5 | PBQ subscale |
| `Positive` | numeric | 1–5 | PBQ subscale |

## Subjective ratings (per trial, adapted from Fuller 2005)

| Column | Type | Values | Description |
|---|---|---|---|
| `Q1` | integer | 1–10 | Perceived difficulty (`PercDiff`) |
| `Q2` | integer | 1–10 | Perceived risk (`PercRisk`) |
| `Q3` | integer | 0–30 | Expected number of accidents in 30 days (`ExpAcc`) |

## Movement-behaviour outcomes (per trial)

| Column | Type | Unit | Description |
|---|---|---|---|
| `lateral_clearance` | numeric | m | Absolute lateral spacing at closest longitudinal approach |
| `longitudinal_distance` | numeric | m | Longitudinal distance at avoidance onset |
| `average_speed` | numeric | m/s | Mean walking speed over the trial |
| `TTC` | numeric | s | Minimum time-to-collision (`minTTC`) |
| `acceleration` | numeric | m/s² | Maximum acceleration |
| `deceleration` | numeric | m/s² | Maximum deceleration, stored **signed (negative)**; more negative = stronger |

## Derived variables (created in `R/00_setup.R`, not stored in the CSV)

| Variable | Description |
|---|---|
| `Q3_c` | Mean-centred `Q3` (ExpAcc), used as a continuous model predictor |
| `Violations_c` | Mean-centred `Violations`, used as a continuous model predictor |
