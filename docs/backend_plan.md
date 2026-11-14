# Backend Build Plan

**Status: planned, not started.** Building begins only when the team gives the go signal. Part of the full design in [`plan.md`](plan.md); data downloads are covered in [`data_download_guide.md`](data_download_guide.md).


## Context
The team asked for a robust, phased plan for the backend only. Decisions from the user:
- **Backend = the Python pipeline only.** No server. It turns data into the JSON files the Flutter app bundles.
- **Claude writes and tests the code** in the cloud session on branch `claude/stoic-einstein-nzq7cm`. The team runs downloads on laptops (this session cannot reach NASA hosts).
- **Real downloads are not ready**, so every phase is built and tested on **sample data** first; real files are swapped in later without changing the model code.
- **Core first, extras later.** Core = weather, z-scores, soil-water simulation, El Niño year counts, confidence, JSON export.
- **Baseline period: 2015–2025 (11 years).** The full 2001–2025 downloads were too large, and SMAP only starts on 2015-03-31, so every layer uses the same period. Consequences: z-scores and SPI rest on 11 years; only about 3–4 El Niño dry seasons fall in this window (e.g., 2015–16, 2018–19, 2023–24), so El Niño counts such as "2 of 3 years" come with very wide intervals; and the sample-size confidence factor can reach Medium at best (High needs 20 or more years). The app must show these limits instead of hiding them.

The go-ahead covers **Phases 0–6**. Phase 7 waits for the team's downloads. Phase 8 items are built only on request. No Flutter code, no pull request.

## Design principles (what makes it robust)
1. **One boundary between data and model.** Every dataset is read by a *loader* that returns a standard table (`date, muni, <variables>` in fixed units). The model only sees standard tables, so sample and real data are interchangeable (`--source sample|real`).
2. **POWER-only core.** The pipeline must run end to end with NASA POWER + ONI + `crops.csv` alone (POWER already has rain and temperature). SMAP, GPM, MODIS and GRACE are *optional layers*: when a layer is absent, the run still succeeds and `data_quality` records what was missing. Until SMAP arrives, the soil-moisture signal is the z-score of the bucket model's own soil water.
3. **Every threshold and assumption in one file**, `pipeline/params.yaml`, each with a `source` and a `needs_expert_review` flag (e.g., heat z > 1 at rice flowering, NIA supply cut in El Niño years, percolation 3–5 mm/day). No magic numbers in code.
4. **Fail loudly on bad input.** Loaders check date continuity, units, plausible ranges and missing-value codes (−999 etc.) and stop with a clear message.
5. **Deterministic.** Fixed random seeds; the same inputs give byte-identical JSON (tested).
6. **Versioned contract.** `schema/muni.schema.json` and `schema/muni_daily.schema.json` carry `schema_version`; every export is validated against them before it is written.
7. **Tests never touch the network.** CI runs `pytest` on every push.

## Layout
```
pipeline/
  pyproject.toml            # deps: numpy, pandas, scipy, pyyaml, jsonschema; dev: pytest, hypothesis
  ani/                      # the package
    config.py               # municipalities, years, paths
    params.yaml             # all thresholds and assumptions (+ source, needs_expert_review)
    crops.csv               # crop traits, one source per row
    loaders/                # power.py, oni.py (core); smap.py, gpm.py, modis.py, grace.py (optional)
    sample/make_sample.py   # deterministic synthetic data with planted drought years
    quality.py              # continuity, units, range, missing-code checks
    et0.py                  # FAO-56 Penman–Monteith
    harmonize.py            # gap fill (≤ 3 days), daily + monthly standard tables
    zscores.py              # SPI (gamma fit), robust z, composites
    enso.py                 # ONI → El Niño / La Niña / neutral per dry season
    soil_water.py           # daily bucket model, Euler's method
    fsm.py                  # crop stages by GDD + stage risk rules
    simulate.py             # rotations × water source × years
    uncertainty.py          # Wilson intervals, confidence level
    export.py               # <muni>.json, <muni>_daily.json, alert parity cases
    run.py                  # one command for the whole pipeline
  tests/                    # unit, known-answer, property, contract
schema/  fixtures/  .github/workflows/ci.yml  docs/json_contract.md
```

## Phases (each ends with a commit, a push and its gate; the next phase starts only when the gate is green)

**Phase 0: Setup.** `pyproject.toml`, package skeleton, `config.py`, CI workflow (Python only), one placeholder test.
*Gate:* `pytest` passes locally and in CI; `git check-ignore pipeline/data/raw/x.nc` succeeds.

**Phase 1: Contract, sample data, crop table.**
- Both JSON schemas with `schema_version`, plus `docs/json_contract.md` explaining every field for the Flutter team.
- Hand-written **mock JSON** for the 3 municipalities in `flutter_app/assets/data/` so app work can start immediately.
- `make_sample.py`: 2015–2025 daily weather per municipality with a wet/dry seasonal cycle and **planted dry years** aligned to a sample ONI file, so later tests have known answers.
- `crops.csv` (rice, onion, mungbean, corn) and `params.yaml`. Values I cannot verify from here are marked `needs_expert_review`.
*Gate:* mock JSON validates against the schema; sample data is identical on two runs; every crop row has a source and plausible ranges.

**Phase 2: Ingest and harmonize.** POWER loader (real CSV format + sample), ONI loader, `quality.py`, `et0.py`, `harmonize.py`.
*Gate:* ET₀ reproduces the FAO-56 worked example (Example 18, 3.9 mm/day within 0.1); a planted −999 and a planted date gap are caught; gaps ≤ 3 days are filled and longer gaps flagged; units and ranges pass on the sample data.

**Phase 3: Z-scores and ENSO.** `zscores.py`, `enso.py`.
*Gate:* per calendar month mean ≈ 0 and SD ≈ 1; SPI handles zero-rain months; planted dry years give water-stress z below −1; ENSO phases match a hand-checked list for the sample ONI file.

**Phase 4: Soil water and crop stages.** `soil_water.py`, `fsm.py`, GDD trapezoid + root finding, stage risk rules read from `params.yaml`.
*Gate:* water balance closes within 0.1 mm; soil water never leaves [0, S_max] (property test); halving the time step changes stress days by < 2%; constant temperature gives the exact analytical harvest day; stages never go backwards.

**Phase 5: Simulation.** `simulate.py` for Rice–Rice, Rice–Onion, Rice–Mungbean (Rice–Corn if cheap) × {NIA, tube well, rainfed} × 2015–2025, then "X of Y years" by all / El Niño / La Niña years. Irrigation supply rules (e.g., reduced NIA supply in El Niño years) are parameters flagged for expert review.
*Gate:* an output row exists for every combination; rainfed dry-season rice is stressed in the planted dry years; mungbean uses less water than dry-season rice; results are identical on two runs.

**Phase 6: Uncertainty, export, one-command run.** Wilson intervals on every frequency; the pipeline-side confidence factors (years of data, satellite-vs-ground; the app adds ranking stability and farmer inputs); `export.py`; `fixtures/alert_cases.json` for Python/Dart parity; `python -m ani.run --source sample`.
*Gate:* Wilson 5 of 7 → 36–92%; every export validates against the schema; byte-identical output on two runs; the run finishes in under ~2 minutes; the sample-based JSON replaces the mock JSON in `flutter_app/assets/data/` (clearly labeled as sample data). **Core backend complete: stop and report.**

**Phase 7: Real data swap-in (needs the team's downloads).** The team places POWER CSVs and the ONI file under `pipeline/data/raw/` and sends me a few lines of each real file so the loaders are tested against the true format. Run `--source real`, commit the small processed tables, export real JSON.
*Gate:* quality checks pass on real files; known dry seasons (2015–16, 2019, 2023–24) show as dry or the mismatch is explained in `docs/data_quality.md`; the Flutter tests still pass with real JSON.

**Phase 8: Optional layers (independent; build in this order, each only on request).**
| # | Layer | Adds | Gate |
|---|---|---|---|
| 8a | SMAP + GPM loaders (AppEEARS / Giovanni CSV) | Observed soil moisture and satellite rain in the z-scores | Run works with and without the layer; the first SMAP year starts 2015-03-31 and is handled as a partial year |
| 8b | Monte Carlo + bootstrap | Ranges on income/water/risk; firm-or-not z labels | Error shrinks as 1/√N; ranges contain the point estimate |
| 8c | Station validation (`validate.py`) | Bias, RMSE, r vs. PAGASA/PhilRice data | Known synthetic bias is recovered |
| 8d | MODIS NDVI phenology | Bare-field windows, crop-stress z | Synthetic NDVI green-up recovered within one composite |
| 8e | GRACE trend | Groundwater trend (province scale) | Known slope recovered within its standard error |
| 8f | Fetch scripts (POWER, AppEEARS API, earthaccess for GRACE) | One-command re-download on laptops | Mocked-response tests; team confirms one real run |

## Working rules during the build
- Report the gate result at the end of each phase (what passed, what failed, with output). A failing gate is fixed before the next phase starts.
- Update `CLAUDE.md` (real commands, real layout) and `docs/plan.md` as code lands.
- Anything I had to assume (crop values, irrigation rules, thresholds) is listed in `docs/assumptions_for_review.md` for the team to check with PhilRice/MAO sources.

## Verification (end to end)
```bash
cd pipeline && pip install -e ".[dev]"
```
```bash
pytest
```
```bash
python -m ani.run --source sample
```
Then confirm: the three `<muni>.json` and `<muni>_daily.json` files exist in `flutter_app/assets/data/`, validate against the schemas, and are identical on a second run; CI is green on the branch.

