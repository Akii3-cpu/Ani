# Ani: Crop-Rotation Helper for Nueva Ecija Farmers (48-hr Hackathon Plan)

## Context
NASA Space Apps-style challenge: build a decision-support tool that uses NASA Earth observations, soil data, crop traits and farmer priorities to compare crop rotations that improve soil health and resilience. The team chose a **farmer-centered crop-rotation** focus for **Nueva Ecija**, with El Niño readiness as the main story. The repo `alyastanga/ani` is empty (README only). *Ani* means "harvest".

**Decisions so far**
- 48-hour hackathon. Deliverables: working prototype, demo video, slides
- Team of 4–6 with Python, JS/React and Flutter/Kotlin skills
- **Flutter** app; results **pre-computed in Python and bundled as JSON** (offline, no server)
- Sites: **Guimba** (irrigated rice–rice), **Bongabon** (rice–onion), **Science City of Muñoz** (PhilRice/CLSU, used for ground validation)
- **Baseline period: 2015–2025 (11 years).** The full 2001–2025 downloads were too large, and SMAP only starts on 2015-03-31, so every layer uses the same period. Consequences: z-scores and SPI rest on 11 years; only about 3–4 El Niño dry seasons fall in this window (e.g., 2015–16, 2018–19, 2023–24), so El Niño counts such as "2 of 3 years" come with very wide intervals; and the sample-size confidence factor can reach Medium at best (High needs 20 or more years). The app must show these limits instead of hiding them.
- Voice: **flutter_tts (fil-PH)** now; recorded Tagalog clips later if time allows
- Methods: monthly **z-scores** → **finite-state-machine (FSM) season simulation** over 2015–2025 → **ENSO analog years** → **weighted-sum/TOPSIS ranking** by farmer priorities (computed on-device in Dart, since it depends on user input)
- **Two features:** (1) crop tracker: farmer enters crop + planting date, app shows growth stage, alerts and a predicted harvest window; (2) rotation advice for the next crop. The tracker feeds the advice at harvest.
- Rotations compared: **Rice–Rice (baseline)**, **Rice–Onion**, **Rice–Mungbean** (+ Rice–Corn if time)

---

## Architecture
```
[Python pipeline, run before/at start of hackathon]
 NASA POWER / GPM / SMAP / MODIS / SRTM + SoilGrids + ONI + crop table
   → harmonize to monthly × 3 municipalities
   → z-scores → FSM simulation per rotation × irrigation × year
   → JSON per municipality  ──►  flutter_app/assets/data/*.json

[Flutter app, offline]
 Farmer inputs → constraint filter → priority weights → TOPSIS ranking
   → picture cards + Filipino sentences → flutter_tts
```

## Repo layout
```
ani/
  pipeline/                 # Python
    config.py               # municipalities (name, lat/lon, bbox), years 2015–2025
    fetch_power.py          # NASA POWER daily API → data/raw/power_<muni>.csv
    fetch_appeears.py       # GPM, SMAP L4, MODIS NDVI/ET, SRTM via AppEEARS area requests
    fetch_soilgrids.py      # ISRIC SoilGrids REST → texture, pH, SOC per muni
    fetch_oni.py            # NOAA CPC ONI → ENSO phase per season
    harmonize.py            # interpolate to muni points + daily/monthly tables, ET₀ (data/processed/)
    soil_water.py           # daily bucket model (Euler's method)
    phenology.py            # Savitzky–Golay NDVI smoothing, green-up/peak/harvest dates
    trends.py               # least-squares trends (GRACE storage, Tmax)
    zscores.py              # per-calendar-month z (SPI-style gamma for rain, robust z for others)
    fsm.py                  # crop-season state machine + transition/risk rules
    simulate.py             # run rotations × irrigation × years → outcomes
    validate.py             # satellite vs. station: bias, RMSE, r
    uncertainty.py          # bootstrap, Wilson intervals, Monte Carlo ranges
    export_json.py          # → flutter_app/assets/data/<muni>.json
    crops.csv               # hand-built crop trait table (see below)
    tests/                  # pytest: unit, known-answer, property (hypothesis), contract
  flutter_app/
    lib/
      main.dart
      models/               # Municipality, Rotation, Outcome, FarmerProfile
      services/data_service.dart   # load JSON assets
      services/ranking.dart        # constraint filter + weighted sum/TOPSIS
      services/harvest.dart        # GDD harvest window + current stage
      services/alerts.dart         # stage × z-score rules, notifications
      services/planting_store.dart # saved plantings (on-device)
      services/speech.dart         # flutter_tts wrapper (fil-PH, slow rate)
      l10n/phrases_fil.dart        # Filipino sentence templates
      screens/  (welcome, location, rotation, water, priorities, results, detail, elnino)
    assets/data/  assets/img/
    test/                   # unit + widget tests
    integration_test/       # end-to-end farmer flows
  schema/muni.schema.json   # JSON contract shared by pipeline and app
  fixtures/                 # shared known-answer cases (e.g., alert_cases.json for Python/Dart parity)
  .github/workflows/ci.yml  # pytest + flutter test on every push/PR
  docs/ data_sources.md  method.md  pitch.md  manual_checklist.md
```

## Data (fetch BEFORE the hackathon if allowed; AppEEARS jobs take hours)
| Source | Product | Variables | Period |
|---|---|---|---|
| NASA POWER API | daily, point per muni | T2M_MAX/MIN, PRECTOTCORR, RH2M, WS2M, ALLSKY_SFC_SW_DWN → FAO-56 ET₀ | 2015–2025 |
| GPM | IMERG Final monthly/daily | precipitation, extreme-rain days | 2015–2025 |
| SMAP | SPL4SMGP (root-zone) | soil moisture | 2015–2025 (starts 2015-03-31) |
| MODIS | MOD13Q1 NDVI, MOD16A2 ET | crop stress, bare-field detection, actual ET | 2015–2025 |
| GRACE/GRACE-FO | JPL mascon | water storage anomaly (province-scale trend) | 2015–2025 (data gap Jun 2017–May 2018) |
| SRTM | GL1 30 m | slope, low-lying %, used for erosion and flood flags | static |
| SoilGrids | 0–30 cm | clay/sand, pH, SOC | static |
| NOAA CPC | ONI | El Niño / La Niña / neutral by DS | 2015–2025 |
| PSA / PhilRice (manual) | yields, farmgate prices | rice, onion, mungbean ₱/kg & t/ha | latest |
| Crop calendar (manual) | PhilRice/DA | WS/DS windows | — |

**Data in the repo.** Raw satellite downloads are never committed (files are hundreds of MB to GB, GitHub rejects files over 100 MB, binary rasters can't be merged, and the fetch scripts can recreate them).

| In the repo | Gitignored |
|---|---|
| Fetch scripts (`fetch_power.py`, `fetch_appeears.py`, …) | Raw GPM, SMAP, MODIS, SRTM, GRACE files (`pipeline/data/raw/`) |
| `crops.csv`, `schema/`, `fixtures/` | AppEEARS download bundles (`pipeline/data/appeears/`) |
| `pipeline/data/README.md`: for each dataset, the product ID, date range, bounding box and download date | Earthdata login/token, `.env` |
| Exported `<muni>.json` and `<muni>_daily.json` in `flutter_app/assets/data/` (the app needs them) | Large intermediate files |
| Small processed tables in `pipeline/data/processed/*.csv` (e.g., POWER daily weather for 3 municipalities, about 1 MB each), so teammates can run the pipeline, tests and app without waiting on NASA downloads | |

Share raw copies between teammates through a shared Drive folder, not git. ECOSTRESS is not part of the final pipeline, so nothing needs downloading for it.

**Prep tasks:** create an Earthdata login, submit AppEEARS area requests for 3 municipality bounding boxes, and download the HDX municipality boundaries.

**`crops.csv` columns:** crop, season_ok, duration_days, water_need_mm, Kc_ini/mid/end, temp_max_ok, flood_tolerance, drought_tolerance, n_fixed_kg_ha, residue_t_ha, root_depth_m, pest_family, erosion_C, yield_t_ha, price_php_kg, cost_php_ha, labor_level, needs_cold_storage. Source values from FAO-56, ECOCROP, PhilRice/PCAARRD guides and PSA. Put a source column on each row.

## Model (pipeline)
1. **Z-scores** (`zscores.py`): for each muni, variable and calendar month, `z = (x − mean_month) / sd_month`. Rain uses SPI (gamma fit); others use robust z (median/MAD). Composite indices: `water_stress = mean(−z_rain, −z_sm, +z_et)`, `heat = z_tmax`, `crop_stress = −z_ndvi`. Labels: ≤−1 "mag-ingat" (be careful), ≤−2 "delikado" (dangerous).
2. **FSM** (`fsm.py`): states `LandPrep → Vegetative → Flowering → Harvest → Bare` per crop, with durations from `crops.csv`. Stage-specific risk rules, e.g.:
   - rice Flowering & heat z>1 → heat_risk
   - DS rice & (irrigation=rainfed or water_stress z>1) → water_fail
   - onion establishment & rain z>2 → rot_risk
   - Bare & rain z>2 & slope>3% → erosion_risk
3. **Simulate** (`simulate.py`): **daily steps**. The FSM advances crop stages by accumulated GDD, and `soil_water.py` updates soil water each day; water stress = days with Ks < 1 at sensitive stages. For each muni × rotation × irrigation ∈ {NIA, tube well, rainfed} × year, output: stressed (y/n), failed (y/n), bare_days, water_use_mm, n_added, erosion_score, est_income, main_reason.
4. **Aggregate + export**: frequencies "X of Y years", split into all years / El Niño years / La Niña years. Also include the monthly z-score series for the charts.

**JSON shape (`<muni>.json`)**
```json
{ "muni":"Guimba", "baseline":"2015–2025",
  "current_conditions": {"water_stress_z":-1.2,"label":"mag-ingat"},
  "rotations":[{"id":"rice_mungbean","crops":["rice","mungbean"],
    "by_irrigation":{"nia":{"all":{"stressed":3,"years":25},"elnino":{"stressed":1,"years":7},
      "water_use_mm":650,"n_added":40,"income_php_ha":0,"bare_days":45,"main_reasons":["..."]}}}],
  "monthly_z":[{"ym":"2024-02","rain":-1.6,"sm":-1.1,"tmax":1.3,"ndvi":-0.8}] }
```

## Ranking (on-device, `ranking.dart`)
1. **Filter:** remove DS rice if there's no DS water. Flag onion if there's no tube well or cold storage. Drop any "won't plant" crops.
2. **Criteria**, normalized 0–1: water use, risk (El Niño frequency when ENSO=El Niño, otherwise all years), income, soil health (N + residue), pest break, labor/cost.
3. **Weights** from the farmer's top-3 priorities (50/30/20); in El Niño mode, add weight to water and risk. Score with TOPSIS (fall back to a weighted sum).
4. Output the top 3 with reason sentences built from `main_reasons` and the z-scores.

## Numerical methods
Name these in the method doc and pitch. Each one has a test.

| # | Method | Where | Detail |
|---|---|---|---|
| 1 | **Euler's method for the soil-water ODE** (core) | `soil_water.py` (+ Dart port in `alerts.dart` for the tracker) | Bucket model `dS/dt = P_eff + I − Kc·ET₀ − D`, daily step Δt = 1 day: `S[t+1] = clamp(S[t] + Δt·(P_eff + I − Kc·ET₀ − D), 0, S_max)`. `S_max` = root depth × available water capacity from soil texture (SoilGrids). Drainage `D = max(0, S − S_fc)` (excess above field capacity drains). For flooded rice, add percolation (~3–5 mm/day) and keep a ponded water layer. Stress coefficient `Ks = S / (p·S_max)` when S < p·S_max (FAO-56 depletion fraction p). Replaces the monthly deficit in the simulation. |
| 2 | **Trapezoidal integration + root finding** for the harvest date | `harvest.dart`, `fsm.py` | Cumulative GDD `G(t) = Σ ½(g_i + g_{i+1})Δt`; harvest date = root of `G(t) − G_target = 0`, found by linear interpolation between the two days that bracket the target (bisection if sub-daily data is used). Same method gives each stage start date. |
| 3 | **Interpolation** | `harmonize.py` | Space: bilinear from coarse grids (POWER 0.5°, GPM 0.1°, SMAP 9 km) to municipality points; area average for MODIS 250 m pixels inside the muni. Time: linear interpolation for gaps ≤ 3 days, flag longer gaps as missing (never interpolate across a whole cloudy month). |
| 4 | **NDVI curve smoothing** | `phenology.py` | Savitzky–Golay filter (window ~5 composites, polynomial order 2) after removing cloud-flagged values; green-up = first crossing of 0.3 found by linear root finding; peak = maximum of the smoothed curve; harvest = drop below 0.2. |
| 5 | **Maximum-likelihood gamma fit** for SPI | `zscores.py` | `scipy.stats.gamma.fit` (iterative MLE, Newton-type solver) per calendar month, with a zero-rain probability term; convert the CDF to a standard normal z. |
| 6 | **FAO-56 Penman–Monteith ET₀** | `harmonize.py` | Evaluate the FAO-56 equation daily from POWER Tmax, Tmin, RH2M, WS2M, solar radiation. Check against POWER's own ET-related outputs or a simpler Hargreaves estimate. |
| 7 | **Least-squares trend regression** | `trends.py` | Linear fit of GRACE/GRACE-FO water storage (mm/yr) and of annual POWER Tmax (°C/decade), with the standard error of the slope. Shown as long-term context, not field values. |
| 8 | **Error and convergence analysis** | `validate.py`, `uncertainty.py`, tests | Absolute/relative error and RMSE (satellite vs. station; predicted vs. actual harvest date). Monte Carlo error ~ 1/√N: report N and the standard error of each "% ranked #1". Euler step check: rerun the bucket model with Δt = 0.5 day; results must change < 2%. |

**Rules:** clamp soil water to [0, S_max] every step; report harvest windows in whole days and probabilities in whole percent; note in the data-quality block that interpolating coarse data does not add field-level detail.

**Tests (`pipeline/tests/test_numerics.py`, `flutter_app/test/harvest_test.dart`):**
- Bucket model conserves water: initial S + inputs − outputs − final S ≈ 0.
- Dry spell with no rain or irrigation: S decreases every day and never goes below 0.
- Halving Δt changes seasonal stress days by < 2%.
- GDD root finding on a constant-temperature series returns the exact analytical date.
- Savitzky–Golay on a synthetic NDVI curve with noise recovers the true green-up date within one composite.
- Trend regression on synthetic data with a known slope recovers it within its standard error.

## Uncertainty
Measure it at each step, combine it into one confidence level, and show farmers plain words.

**Pipeline (`validate.py`, `uncertainty.py`)**
1. **Data:** compare POWER/GPM with the PAGASA/PhilRice Muñoz station → bias, RMSE, correlation r. Flag pixel size, record length (11 years), % missing/cloudy months, and SoilGrids vs. BSWM disagreement.
2. **Baseline:** bootstrap the baseline years (1,000×) and recompute the monthly mean/SD → a z-score range per month. A label is "firm" only if the whole range stays on one side of the threshold.
3. **Frequencies:** a Wilson interval on every "X of Y years" (e.g., 5 of 7 → 71%, range 36–92%).
4. **Model sensitivity:** Monte Carlo (~500 runs), drawing crop parameters from ranges (yield, price, duration, water need) and shifting rule thresholds ±20% → ranges for income, water use and risk.
5. **Ranking stability** (on-device in `ranking.dart`, ~200 runs): jitter priority weights ±10% and criterion values within their ranges → % of runs each rotation ranks #1.
6. **Harvest window:** normal/warm/cool temperatures × the variety's days-to-maturity range, + ±5 days. Log actual harvest dates entered by farmers to measure the real error later.
7. **Optional ML:** leave-one-year-out CV, prediction intervals, calibration check.

**Confidence level** = the lowest of four factors:
| Factor | High | Medium | Low |
|---|---|---|---|
| Sample size | ≥ 20 yrs | 10–19 | < 10 |
| Satellite vs. ground | r ≥ 0.8 | 0.6–0.8 | < 0.6 or no station |
| Ranking stability | #1 in ≥ 70% | 50–70% | < 50% |
| Farmer inputs | all key answers | some | location only |

**JSON additions:** `ci_low`, `ci_high` on each frequency; `range` on income/water; `confidence` + `confidence_reasons` per rotation; a `data_quality` block per municipality (bias, RMSE, r, years per variable, missing %).

**In the app:**
- 🟢 **Sigurado** (sure) / 🟡 **Medyo sigurado** (fairly sure, ask the MAO) / 🔴 **Hindi pa sigurado** (not sure yet, ask an expert), shown and read aloud on each result card
- Ranges drawn as icons (e.g., 5–9 withered plants of 20) and a "**Bakit?**" (Why?) button giving the main reason
- Technician screen with the detailed numbers
- Two near-tied rotations → "Parehong mabuti; pag-usapan sa MAO." (Both are good; discuss with the MAO.)

**Tests:** Wilson interval known values; bootstrap ranges contain the point estimate; the confidence level drops when a factor is low.

## Crop tracker: "Aking Tanim" (My Crop)
Farmers record what is already planted and when; the app follows the crop and predicts harvest. It reuses the FSM stages and z-scores, and it hands over to the rotation advice at harvest.

**Farmer inputs:** crop (picture tap), planting date (date picker; for rice also *lipat-tanim* transplanted vs *sabog-tanim* direct-seeded), optional variety maturity (maaga / katamtaman / matagal = early / medium / late), optional field name. Several plantings allowed. Stored on the phone only (`shared_preferences`, JSON list).

**Harvest prediction (`harvest.dart`, on-device):**
- Method: **growing degree days (GDD)**. `GDD_day = max(0, (Tmax + Tmin)/2 − T_base)`, summed from the planting date until the crop's `gdd_to_maturity`.
- New `crops.csv` columns: `t_base_c`, `gdd_to_maturity` per maturity class, and stage fractions (share of GDD at which vegetative / flowering / maturity begin). Derive `gdd_to_maturity` as typical days-to-maturity × the site's normal daily GDD, so it matches local guides; cite the source for each duration.
- Temperatures: actual NASA POWER daily values up to the export date, then the day-of-year normals (2015–2025) for the rest of the season.
- Output a **window, not one date**: "Inaasahang ani: Marso 10–20" (expected harvest), plus days remaining. Window = run with normal, warm (+1 sd) and cool (−1 sd) temperatures, with a minimum of ±5 days.
- Limits to state in the app: lowland temperatures vary little, so the estimate stays close to the variety's usual duration; variety, transplant shock, water stress and photoperiod-sensitive traditional rice shift it. The farmer checks grain/bulb/pod maturity before harvesting.

**Monitoring:**
- Stage timeline (land prep → vegetative → flowering → maturity → harvest) with "you are here", from accumulated GDD.
- Stage-specific alerts from the same rules as `fsm.py`, ported to Dart: e.g., rice at flowering + heat z > 1; onion bulbing + soil moisture z < −1. Conditions come from the bundled latest month, refreshed when online.
- A short tip per stage in Filipino, read aloud.
- Optional farmer check-in: "Kumusta ang tanim?" (How is the crop?) → mabuti / naninilaw / may peste (fine / yellowing / pests), saved as a log and shown on the timeline.
- Local notifications (`flutter_local_notifications`): stage change, harvest in 14 and 7 days.
- At harvest: button "Ano ang susunod na itatanim?" (What to plant next?) opens the rotation ranking with the current crop pre-filled.

**Data for the tracker:**
- Pipeline adds `export_daily.py` → `assets/data/<muni>_daily.json`: day-of-year normals and sd for Tmax, Tmin, rain, ET₀, plus actual daily values for the last 12 months.
- Optional online refresh: the app calls the NASA POWER daily API directly (free, no key; data lags a few days) and caches it. The app works without it.
- Not in scope: per-field satellite monitoring. MODIS at 250 m and cloudy wet-season images can't follow one small field reliably; NDVI stress is shown at municipality level only.

## Flutter app screens
0. **Home**: two big buttons, "Aking Tanim" (track my crop) and "Payo sa Susunod na Tanim" (advice for next crop), plus the El Niño banner
0a. **Add planting**: crop, planting date, method, maturity class
0b. **Crop monitor**: stage timeline, harvest window, alerts, tip, check-in, 🔊
1. **Welcome**: language (Filipino/English) and 🔊 auto-read toggle
2. **Location**: pick Guimba / Bongabon / Muñoz (pictures + map pin)
3. **Current rotation**: tap crop pictures for Tag-ulan and Tag-araw
4. **Water**: NIA canal / poso-bomba (well or pump) / ulan lang (rain only); "Sapat ba ang tubig sa Tag-araw?" (Is there enough water in the dry season?)
5. **Priorities**: tap the top 3 of 💧 tipid-tubig (save water), 💰 kita (income), 🌱 lupa (soil), 🛡️ ligtas (low risk), 🐛 peste (pests)
6. **Results**: 3 cards (🟢/🟡/🔴, "X sa Y taon" with plant icons, water buckets, income), each read aloud
7. **Detail**: why it was suggested, evidence (simple z chart), benefits, risks, data gaps, "Kumonsulta sa MAO" (consult the Municipal Agriculture Office)
8. **El Niño banner/page**: ONI status, past El Niño outcomes, what to do now

Packages: `flutter_tts`, `fl_chart`, `shared_preferences`. `flutter_map` is optional. TTS: `setLanguage("fil-PH")`, rate ~0.4, with English fallback if the fil-PH voice is missing.

**Filipino TTS options (all downloadable, offline):**
1. **Default:** Google's on-device Filipino voice. On the demo phone: Settings → Text-to-speech → Speech Services by Google → Install voice data → Filipino. `flutter_tts` uses it with no internet. Call `isLanguageAvailable("fil-PH")` at startup.
2. **Backup:** Meta **MMS-TTS Tagalog** (`facebook/mms-tts-tgl`, Hugging Face). Pre-generate `.wav` files for fixed phrases in Python (`transformers` VitsModel) and bundle them in `assets/audio/`, played with `audioplayers`. License is CC-BY-NC, which is fine for a hackathon, not for commercial use.
3. **Later:** run MMS Tagalog on-device through the `sherpa_onnx` Flutter package (convert to ONNX, or use a pre-converted `vits-mms-*` model if one exists for Tagalog).

## 48-hour schedule
| Hours | Data (2) | Flutter (2) | Design/Filipino content (1) | Pitch/research (1) |
|---|---|---|---|---|
| 0–4 | fetch POWER, ONI, SoilGrids; check AppEEARS jobs | scaffold app, screens 1–5 with mock JSON | icons, colors, Tagalog templates | crop table values, sources |
| 4–16 | harmonize, z-scores, FSM | input flow, profile storage | review wording with native speakers | data_sources.md |
| 16–28 | simulate, export real JSON | results + ranking.dart + TTS | result card designs | method.md, slides draft |
| 28–40 | validate vs PAGASA/PSA; fix rules | detail + El Niño screens, charts | test with someone non-technical | demo script |
| 40–48 | freeze data | polish, APK build | screenshots | record video, final slides |

**Numerical-methods work inside this schedule:** hours 4–16: interpolation, ET₀, `soil_water.py` with its tests (needed before the simulation); hours 16–28: GDD root finding (Python + Dart), `phenology.py`; hours 28–40: `trends.py`, step-size and convergence checks. If time runs short, keep 1, 2, 3 and 8 and drop NDVI smoothing and trends.

**Uncertainty work inside this schedule:** data team adds Wilson intervals and the confidence level in hours 16–28 and the Monte Carlo/bootstrap and `validate.py` in hours 28–40; Flutter adds the confidence badge and "Bakit?" with the results screen; the pitch gets one slide: "We show how sure we are, and where farmers and experts need to check."

**Tracker work inside this schedule:** Flutter dev A owns the rotation flow, Flutter dev B owns the tracker (add planting + GDD harvest window + timeline by hour 16; alerts and notifications by hour 28; online refresh and check-in log only if time remains). Data team adds `export_daily.py` in hours 4–16.

**Freeze rule:** the app must run on mock JSON by hour 8 so the app work never waits on the data team.

## Demo script (2–3 min)
A farmer in Guimba who grows rice–rice with NIA irrigation picks the priorities "tipid-tubig + ligtas". El Niño is on. The app says (and reads aloud) that dry-season rice struggled in X of Y El Niño years and recommends Rice–Mungbean, with Rice–Onion as the second choice if the farmer has a well. Then switch to Bongabon to show onion. End with "Kumonsulta sa MAO."

## Testing and task gates
**Rule:** every task has a gate. All of its checks must pass, and CI must be green, before the next task starts.

**Test types**
| Type | Checks | Tool |
|---|---|---|
| Unit | One function gives the right answer | `pytest`, `flutter_test` |
| Known-answer | Synthetic input with a known result (constant 25 °C → exact harvest day) | Fixture files |
| Property | Invariants: soil water never < 0, stages never go backwards | `hypothesis`; random-input loops in Dart |
| Contract | Pipeline JSON matches what the app expects | `schema/muni.schema.json`, validated in Python (`jsonschema`) and in a Dart test |
| Parity | `fsm.py` and `alerts.dart` give the same alerts | `fixtures/alert_cases.json`, used by both test suites |
| Widget | Screens show the right content (badge color, "X sa Y taon") | `flutter_test` |
| End-to-end | Full farmer flows | `integration_test` on an emulator or phone |
| Manual | Filipino voice, offline mode, comprehension | `docs/manual_checklist.md`, signed off by a teammate |

**Task order and gates**
| # | Task | Gate |
|---|---|---|
| 0 | Repo setup (folders, pytest, Flutter project, CI, `.gitignore` for raw data and credentials) | CI runs on push; one placeholder test passes on each side; `git check-ignore pipeline/data/raw/x.nc` confirms raw files are ignored |
| 1 | JSON contract + mock JSON | Mock validates against the schema; the app loads it in a test |
| 2 | `crops.csv` | Every row has a source; no missing values; durations and water needs in plausible ranges |
| 3 | Fetch scripts | One file per municipality; continuous dates; correct units; no impossible values |
| 4 | Harmonize + ET₀ | ET₀ matches the FAO-56 worked example; interpolation of a known grid is exact; gaps > 3 days flagged, not filled |
| 5 | Z-scores | Per month mean ≈ 0, SD ≈ 1; SPI matches a reference value; 2019 DS gives z < −1 |
| 6 | Soil-water model | Water balance closes (< 0.1 mm); dry spell → falls, never < 0; halving Δt changes results < 2% |
| 7 | FSM + simulate | Stages follow crop durations; never go backwards; rainfed DS rice in El Niño years flagged; outputs for every rotation × water source × year |
| 8 | Uncertainty | Wilson known values (5 of 7 → 36–92%); bootstrap range contains the estimate; confidence drops when any factor is low |
| 9 | Export real JSON | Passes the contract test; app tests pass with real JSON instead of mock |
| 10 | `ranking.dart` | No DS water → DS rice removed; "save water" at 100% → lowest-water rotation #1; same seed → same Monte Carlo result |
| 11 | `harvest.dart` | Constant temperature → exact day; warmer → earlier; window contains planting date + guide duration |
| 12 | `alerts.dart` | Parity with `fsm.py` on all shared cases |
| 13 | Screens | Widget test per screen; full input → results flow passes in `integration_test` |
| 14 | TTS + offline | Manual: airplane mode on, fil-PH voice reads every result card, English fallback when the voice is missing |
| 15 | Usability | A non-technical person (ideally a farmer) completes the flow unaided and explains the result back |

**Enforcement**
- GitHub Actions runs `pytest pipeline/tests` and `flutter test` on every push and PR; a red CI blocks the merge.
- One branch per task. The PR description lists that task's gate as checkboxes.
- Write the known-answer fixture before the code (test-first).
- If time runs short, never skip the soil-water, harvest-date, contract and parity tests. Widget tests can be trimmed.

## Verification
- `pytest pipeline/tests`: z-scores have mean≈0 and sd≈1 per month; FSM transitions follow the crop durations; known drought years (e.g., 2015–16, 2019, 2024 DS) show water_stress z<−1.
- Compare POWER/GPM rain with the PAGASA/PhilRice Muñoz station (correlation and bias) if the data is obtainable. Otherwise list this as a data gap.
- Check that the NDVI-detected bare months match the crop calendar.
- `flutter test` for harvest.dart: a rice crop planted on a known date gives a harvest window that contains planting date + the guide's days-to-maturity; warmer temperatures give an earlier date; stage order never goes backwards.
- `flutter test` for ranking.dart (filter + weights). Run the app on a low-end Android phone with no internet, and check that fil-PH TTS speaks.

## Risks / fallbacks
- AppEEARS is slow → use POWER plus GPM monthly only, and add SMAP/MODIS later.
- Phone has no fil-PH TTS voice → English TTS plus on-screen Tagalog; record clips if time allows.
- Price/yield values are uncertain → show ranges and label them "kailangang i-verify" (needs verification).
- Every result screen includes a disclaimer: suggestions only; final decision is with the farmer and the MAO/PhilRice.
