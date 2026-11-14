# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Status

The repository contains only a placeholder `README.md`. No code exists yet. Everything below describes the **agreed design** for a 48-hour hackathon build. Update this file as the real code lands, and replace "planned" items with what actually exists. The team has asked that building not start until they say so.

## Project

**Ani** ("harvest" in Filipino) is a farmer-facing decision-support app for **Nueva Ecija, Philippines**, made for a NASA Space Apps-style challenge. It has two features:

1. **Crop tracker ("Aking Tanim")**: the farmer enters the crop and planting date. The app shows the growth stage, stage-specific alerts and a predicted harvest **window**.
2. **Rotation advice**: compares **Rice–Rice (baseline)**, **Rice–Onion** and **Rice–Mungbean** (Rice–Corn optional) for the farmer's priorities, with El Niño readiness as the main use case.

There are three sample municipalities: **Guimba** (irrigated rice–rice), **Bongabon** (rice–onion) and **Science City of Muñoz** (PhilRice/CLSU station, used for ground validation).

Users are farmers who may have little formal education. UI text is plain Tagalog/Taglish with pictures and traffic-light colors, and it is read aloud with `flutter_tts` (`fil-PH`, English fallback). Every result must carry a disclaimer to consult the MAO (Municipal Agriculture Office) or PhilRice.

## Baseline period

**Baseline period: 2015–2025 (11 years).** The full 2001–2025 downloads were too large, and SMAP only starts on 2015-03-31, so every layer uses the same period. Consequences: z-scores and SPI rest on 11 years; only about 3–4 El Niño dry seasons fall in this window (e.g., 2015–16, 2018–19, 2023–24), so El Niño counts such as "2 of 3 years" come with very wide intervals; and the sample-size confidence factor can reach Medium at best (High needs 20 or more years). The app must show these limits instead of hiding them.

## Architecture (planned)

There are two halves, connected only through bundled JSON files. **There is no server.**

```
pipeline/ (Python, run offline)            flutter_app/ (Dart, runs offline on phone)
NASA POWER, GPM, SMAP, MODIS, SRTM,        assets/data/<muni>.json, <muni>_daily.json
GRACE + SoilGrids, ONI, crops.csv    ──►   ranking.dart  (filter → weights → TOPSIS)
 → harmonize → zscores → soil_water        harvest.dart  (GDD + root finding)
 → fsm/simulate → uncertainty → export     alerts.dart   (stage × z-score rules)
```

Key design points that span files:

- **Ranking is computed on the device, not in Python**, because it depends on farmer inputs (priorities, water source, constraints). The pipeline exports per-rotation outcome statistics, and `ranking.dart` filters, weights (top-3 priorities → 50/30/20, with extra weight on water/risk in El Niño mode) and ranks them with TOPSIS.
- **Season simulation runs on daily steps.** A finite-state machine (`fsm.py`) advances crop stages by accumulated growing degree days. `soil_water.py` updates a bucket model each day with Euler's method (`dS/dt = P_eff + I − Kc·ET₀ − D`, clamped to `[0, S_max]`). Water stress means days where `Ks < 1` at sensitive stages. Runs cover every municipality × rotation × irrigation type (`nia` / tube well / rainfed) × year, 2015–2025.
- **Z-scores are computed per calendar month** (never across months). Rain uses SPI (a maximum-likelihood gamma fit); other variables use robust z (median/MAD). The composites are `water_stress = mean(−z_rain, −z_sm, +z_et)`, `heat = z_tmax` and `crop_stress = −z_ndvi`.
- **Stage risk rules exist in both Python (`fsm.py`) and Dart (`alerts.dart`)**. Keep them in sync.
- **ENSO analogs**: outcomes are aggregated as "X of Y years" for all years, El Niño years and La Niña years (from the NOAA ONI). Every frequency carries a Wilson interval (`ci_low`, `ci_high`).
- **Confidence level** = the lowest of four factors: years of data, satellite-vs-station agreement, ranking stability (% of Monte Carlo runs ranked #1) and completeness of farmer inputs. It is shown as Sigurado / Medyo sigurado / Hindi pa sigurado.
- **Harvest prediction**: trapezoidal GDD sum from the planting date, with the harvest date found as the root of `G(t) − G_target`. Actual POWER temperatures are used up to the export date, then day-of-year normals. Output is a window from normal/warm/cool runs, never a single date.
- **Never commit raw satellite files** (POWER/GPM/SMAP/MODIS/SRTM/GRACE downloads). Commit only the fetch scripts, `pipeline/data/README.md`, small processed tables and the exported app JSON. `.gitignore` enforces this.
- **NASA data is municipality-scale, not field-scale.** Don't present POWER/GPM/SMAP/GRACE values as per-field measurements.
- `crops.csv` is the hand-built crop trait table that drives the simulation, ranking and tracker. Every row needs a source column.

## Workflow rule: test gates

The team requires every task to pass its test gate before the next task starts. The gates are listed in `docs/plan.md` under "Testing and task gates". Don't begin a task while an earlier task's gate is failing. The JSON contract (`schema/muni.schema.json`) and the Python/Dart parity fixtures (`fixtures/alert_cases.json`) must stay passing on both sides.

## Commands (planned; verify once code exists)

```bash
pytest pipeline/tests                                   # all pipeline tests
pytest pipeline/tests/test_numerics.py -k bucket        # single test
cd flutter_app && flutter test                          # all app tests
cd flutter_app && flutter test test/harvest_test.dart   # single file
```

## Environment notes

- NASA POWER and other external data hosts may be blocked in the cloud container. Data fetching is expected to run on team members' machines, and the cloud container has no Flutter SDK.
- MODIS/GPM/SMAP/SRTM come through NASA AppEEARS, which needs an Earthdata login. Requests take hours, so submit them early.

## Planning reference

The full approved plan (data sources, JSON schema, screens, 48-hour schedule, tests, fallbacks) was written outside the repo during the planning session. If a `docs/` copy exists, treat it as the source of truth for scope.
