# Ani UI/UX Plan (farmer-centered)

**Status: planned, not started.** No Flutter code exists yet. Part of the full design in [`plan.md`](plan.md). Where this document and the "Flutter app screens" section of `plan.md` differ, this document is the newer one.

## Context
`docs/plan.md` lists the screens but not what is on each one, how they connect, or how they behave. The Flutter team needs that before scaffolding. Users are farmers, many with little formal schooling, on low-end Android phones, outdoors, offline.

**Team decisions this plan follows:**
- **English is the base language.** Every string is written in English first. **Filipino is a translation** shown to Filipino farmers.
- **Scope today is Nueva Ecija only** (Guimba, Bongabon, Muñoz). **The design must be able to grow worldwide**, so nothing in the UI is hard-wired to Nueva Ecija, Filipino or the Philippines.
- **Voice (TTS) is optional** and is configured in Settings. The app must be fully usable with voice off.

## Design rules (every page)
1. **One question per page.** One answer area, one primary button ("Next") at the bottom, in thumb reach.
2. **Picture + word on every choice.** Because voice is optional, pictures and short words must carry the meaning alone.
3. **Taps only.** No typing, no swipe-only, no long-press, no hidden menus, no timeouts.
4. **Counts, not percentages or z-scores.** "Struggled in 3 of 11 years", drawn as 11 plant icons with 3 withered.
5. **Color never stands alone.** Green/yellow/red always come with a shape and a word (✔ Good, ! Be careful, ✖ Danger).
6. **Same top bar everywhere:** ← Back, 🏠 Home, and 🔊 (only when voice is on).
7. **Nothing is lost.** Answers save as tapped, can be changed, and the app reopens where the farmer left off.
8. **Honest about limits.** Every result carries the "ask your local agriculture office" disclaimer; El Niño counts say how few years they rest on.
9. **Sized for the field:** tap targets ≥ 56 dp (choice cards about 96 dp), body text ≥ 18 sp, light high-contrast theme, system font scaling respected.

## Navigation
Hub and spoke: Home is the hub; the two features are short flows that return to Home. No bottom bar, no drawer.

```
First open:  P1 Language → P2 Location → P3 Home
P3 Home ─┬─ My Crop ── no planting → P4 Crop → P5 Date → P6 Details → P7 Confirm → P8 Monitor
         │             has planting → P8 Monitor ──► "What should I plant next?" ──┐
         ├─ Advice: P9 Current crops → P10 Water → P11 What matters → P12 Results → P13 Detail
         ├─ Alert banner → P14 El Niño                                  ▲──────────┘
         └─ ⚙ P15 Settings → P16 For technicians, P17 About and data
```

Changes from `docs/plan.md`: (a) location moves to first-run setup, because the tracker needs it too; (b) no separate "won't plant" page, each result card has a "Not for me" button instead; (c) voice toggle moves from Welcome to Settings.

## Pages and their contents
Each page has a wireframe (layout sketch, not final art) followed by its contents. English base text is shown. `[brackets]` give the Filipino term already agreed in `docs/plan.md`. "Data" names the source of what the page shows.

### P1 Language (first open only)
```
            Ani 🌾
   Farm advice from space data

  ┌──────────────────────────┐
  │ ◉  English               │
  └──────────────────────────┘
  ┌──────────────────────────┐
  │ ○  Filipino              │
  └──────────────────────────┘

  [          Next ▸          ]
```
- **Purpose:** pick the app language.
- **Contents:** Ani logo and one-line tagline · language buttons, each written in its own language ("English", "Filipino"), phone language pre-selected · "Next".
- **Notes:** no voice toggle here. Reachable later from Settings.

### P2 Location (first open; later from Settings)
```
  Where is your farm?

  ┌──────────────────────────┐
  │ [photo]  Guimba          │
  ├──────────────────────────┤
  │ [photo]  Bongabon        │
  ├──────────────────────────┤
  │ [photo]  Muñoz           │
  └──────────────────────────┘
        (small map, pins)
  [          Next ▸          ]
```
- **Purpose:** choose where the farm is.
- **Contents:** title "Where is your farm?" · one photo card per available place (Guimba, Bongabon, Science City of Muñoz) · small map with pins (decoration only) · "Next".
- **Data:** the list comes from the bundled `assets/data/*.json`, not hard-coded.
- **State:** if only one place exists, skip the page.

### P3 Home
```
  Ani · Guimba               ⚙
  ┌──────────────────────────┐
  │ ! El Niño is here. See ▸ │
  └──────────────────────────┘
  ┌──────────────────────────┐
  │ 🌾 Rice · Flowering      │
  │ Harvest: March 10–20     │
  │ ! Hot this week          │
  └──────────────────────────┘
  ┌──────────────────────────┐
  │ 🌱  MY CROP              │
  └──────────────────────────┘
  ┌──────────────────────────┐
  │ 🔄  ADVICE FOR NEXT CROP │
  └──────────────────────────┘
  Advice only. Ask your
  agriculture office.
```
- **Purpose:** the hub, and a dashboard for returning farmers.
- **Contents, top to bottom:**
  1. Header: app name, current place, ⚙ Settings.
  2. Climate alert banner (only when active): "! El Niño is here. See what to do ▸" → P14.
  3. One status card per saved planting: crop picture, stage name, "Harvest: March 10–20", worst current alert with its color and symbol → P8.
  4. Big button **My Crop** `[Aking Tanim]` → P4 (no planting) or P8 (one planting) or the list of cards above (several).
  5. Big button **Advice for Next Crop** `[Payo sa Susunod na Tanim]` → P9.
  6. Footer line: "Advice only. Ask your agriculture office."
- **Data:** saved plantings (on phone), `current_conditions`, ENSO status.
- **States:** first visit shows only the two big buttons and a one-line hint under each.

### P4 Add planting: Crop
```
  ← 🏠                 ● ○ ○
  What did you plant?

  ┌───────────┐ ┌───────────┐
  │    🌾     │ │    🧅     │
  │   Rice    │ │   Onion   │
  └───────────┘ └───────────┘
  ┌───────────┐ ┌───────────┐
  │    🫘     │ │    🌽     │
  │ Mungbean  │ │   Corn    │
  └───────────┘ └───────────┘
  [          Next ▸          ]
```
- **Contents:** step dots (1 of 3) · "What did you plant?" · crop picture grid (rice, onion, mungbean, corn) · "Next" (disabled until one is chosen).
- **Data:** crops available for this place.

### P5 Add planting: Date
```
  ← 🏠                 ● ● ○
  When did you plant it?

  [Today] [Yesterday] [Last week]

  ◂      November 2026       ▸
   S   M   T   W   T   F   S
   1   2  (3)  4   5   6   7
   8   9  10  11  12  13  14
   …
  Planted: November 3
  [          Next ▸          ]
```
- **Contents:** step dots (2 of 3) · "When did you plant it?" · quick buttons Today / Yesterday / Last week · large-cell calendar with localized month names, future dates disabled · the chosen date written out in words · "Next".

### P6 Add planting: Details
```
  ← 🏠                 ● ● ●
  How did you plant?   (rice only)
  ┌───────────┐ ┌───────────┐
  │ [picture] │ │ [picture] │
  │Transplant │ │Direct seed│
  └───────────┘ └───────────┘
  How long does your variety take?
  [Early] [Medium] [Late]
  [◉ I don't know]

  Field name (optional) [______]
  [          Next ▸          ]
```
- **Contents:** step dots (3 of 3) · rice only: method, two picture cards transplanted `[lipat-tanim]` / direct-seeded `[sabog-tanim]` · variety maturity: early / medium / late / **I don't know** (pre-selected, uses medium) · optional field name (the only text field in the app) · "Next".
- **State:** for non-rice crops the method block is hidden.

### P7 Add planting: Confirm
```
  ← 🏠
            🌾
  Rice, transplanted,
  planted November 3

  ┌──────────────────────────┐
  │ ✔  Save                  │
  └──────────────────────────┘
  ┌──────────────────────────┐
  │ ✎  Change                │
  └──────────────────────────┘
```
- **Contents:** crop picture · summary sentence "Rice, transplanted, planted November 3" · ✔ **Save** · ✎ **Change** (back to P4 with answers kept).
- **After save:** ask notification permission with the reason "We will remind you before harvest", then go to P8.

### P8 Crop monitor
```
  ← 🏠   Rice · Field 1   ✎ 🗑
  Planted November 3

        [stage picture]
          FLOWERING
  🟫──🌱──🌾──🌾──🧺
          ▲ You are here

  ┌──────────────────────────┐
  │ Expected harvest         │
  │ March 10–20 · 34 days    │
  │ [calendar strip ▒▒▒]     │
  │ Estimate. Check the grain│
  └──────────────────────────┘
  ┌──────────────────────────┐
  │ ! Hot this week          │
  │ Keep water in the field  │
  └──────────────────────────┘
  Tip: …
  How is your crop?
  [🙂 Fine] [🍂 Yellow] [🐛 Pests]
  [ What should I plant next? ]   (at maturity)
  Data up to: Nov 10 · Advice only
```
- **Purpose:** where is my crop now, when is harvest, is anything wrong.
- **Contents, top to bottom:**
  1. Header: crop picture, field name, planting date, ✎ edit, 🗑 delete (with confirm).
  2. **Stage:** large stage picture and name, then a five-picture timeline (land prep → vegetative → flowering → maturity → harvest) with "You are here".
  3. **Harvest card:** "Expected harvest: March 10–20", "34 days left", a mini calendar with the window highlighted. Caption: "This is an estimate. Check the grain before harvesting."
  4. **Alerts** (worst first): symbol and color, what is happening, **what to do**. If none: green "No warnings now".
  5. **Tip for this stage:** one or two sentences.
  6. **Check-in:** "How is your crop?" `[Kumusta ang tanim?]` with picture buttons fine / yellowing / pests. One tap logs it; past check-ins appear as marks on the timeline.
  7. At maturity only: full-width button **What should I plant next?** → P9 with this crop pre-filled.
  8. Footer: "Data up to: <date>" and the disclaimer.
- **Data:** `<muni>_daily.json` (GDD, harvest window), latest monthly z-scores (alerts), `alerts.dart` rules.
- **States:** harvest window passed → "Did you harvest?" Yes (enter date, archive planting) / Not yet.

### P9 Advice: Current crops
```
  ← 🏠                 ● ○ ○
  What do you plant now?

  Wet season
  [🌾 Rice] [🌽 Corn] [∅ Nothing]

  Dry season
  [🌾 Rice] [🧅 Onion] [🫘 Mungbean]
  [🌽 Corn] [∅ Nothing]

  [          Next ▸          ]
```
- **Contents:** step dots (1 of 3) · "What do you plant now?" · two rows of crop pictures, one per season: Wet season `[Tag-ulan]`, Dry season `[Tag-araw]`, plus "Nothing (fallow)" · "Next".
- **State:** pre-filled from the tracker when a planting exists.

### P10 Advice: Water
```
  ← 🏠                 ● ● ○
  Where does your water come from?
  ┌────────┐ ┌────────┐ ┌────────┐
  │[canal] │ │ [pump] │ │ [rain] │
  │  NIA   │ │Well or │ │  Rain  │
  │ canal  │ │  pump  │ │  only  │
  └────────┘ └────────┘ └────────┘
  Enough water in the dry season?
  [✔ Yes] [~ Sometimes] [✖ No]

  [          Next ▸          ]
```
- **Contents:** step dots (2 of 3) · "Where does your water come from?" · three picture cards: canal (labeled "NIA canal" here) / well or pump `[poso-bomba]` / rain only `[ulan lang]` · then "Is there enough water in the dry season?" Yes / Sometimes / No · "Next".

### P11 Advice: What matters to you
```
  ← 🏠                 ● ● ●
  Tap up to 3, most important first
  ┌───────────┐ ┌───────────┐
  │① 💧       │ │   💰      │
  │Save water │ │  Income   │
  └───────────┘ └───────────┘
  ┌───────────┐ ┌───────────┐
  │   🌱      │ │② 🛡       │
  │   Soil    │ │ Low risk  │
  └───────────┘ └───────────┘
  ┌───────────┐
  │   🐛      │  [I don't know]
  │Fewer pests│
  └───────────┘
  [       See advice ▸       ]
```
- **Contents:** step dots (3 of 3) · "Tap up to 3, most important first" · five picture tiles: save water, income, soil, low risk, fewer pests · a number stamp (1, 2, 3) appears in tap order, tap again to remove · "I don't know" (equal weights) · "See advice".
- **Note:** fewer than three is allowed; this lowers the farmer-input confidence factor, as planned.

### P12 Results
```
  ← 🏠
  Guimba · NIA canal · 💧🛡   ✎
  ! El Niño: water and safety first
  We only have 11 years of data,
  so no advice is fully sure.
  ┌──────────────────────────┐
  │ ★ BEST FIT               │
  │ 🌾 Rice → 🫘 Mungbean    │
  │ ✔ Struggled: 2 of 11 yrs │
  │ 🌱🌱🌱🌱🌱🌱🌱🌱🌱🥀🥀   │
  │ Water   💧💧○○○          │
  │ Income  ₱₱₱○○ (estimate) │
  │ How sure  ●●○ Fairly sure│
  │ [ Why? ]   [ Not for me ]│
  └──────────────────────────┘
  ┌──────────────────────────┐
  │ 2  🌾 Rice → 🧅 Onion    │
  │ Needs a well and storage │
  │ …                        │
  └──────────────────────────┘
  ┌──────────────────────────┐
  │ Yours now: Rice → Rice   │
  │ ✖ Struggled: 6 of 11 yrs │
  └──────────────────────────┘
  Advice only. The decision is
  yours. Ask the MAO or PhilRice.
```
- **Purpose:** compare rotations for this farmer.
- **Contents, top to bottom:**
  1. Summary strip of the answers (place, water, priorities) with ✎ Change.
  2. El Niño note when active: "El Niño: water and safety come first."
  3. One-time note: "We only have 11 years of data, so no advice is fully sure."
  4. **Up to three rotation cards**, best first. Each card:
     - Rank label (★ Best fit / 2 / 3) and crop pictures with names (Rice → Mungbean).
     - Risk: color + symbol + "Struggled in 2 of 11 years" + icon row.
     - Water use: 1 to 5 buckets.
     - Income: 1 to 5 coin stacks, a ₱ range, "estimate, needs checking".
     - How sure: three dots + Sure / Fairly sure / Not sure yet `[Sigurado / Medyo sigurado / Hindi pa sigurado]`.
     - A requirement note when relevant: "Needs a well and cold storage."
     - Buttons: **Why?** → P13 · **Not for me** (removes the card, next option moves up, with Undo).
  5. The farmer's current rotation, labeled "Yours now", in the same card format for comparison.
  6. Near-tie message when it applies: "Both are good. Talk to the MAO."
  7. Disclaimer: "This is advice only. The decision is yours. Ask the MAO or PhilRice."
- **Data:** `rotations[].by_irrigation`, ranked on-device by `ranking.dart`.
- **States:** all options removed or filtered out → "No option fits these answers" with Change answers and the agriculture office contact line.

### P13 Detail (Why?)
```
  ← 🏠
  ★ 🌾 Rice → 🫘 Mungbean

  Why this
   Mungbean needs far less water…
  The good
   💧 Saves water   🌱 Feeds the soil
  The risk
   💰 Lower income than onion
  Past years
   All:      🌱🌱🌱🌱🌱🌱🌱🌱🌱🥀🥀
   El Niño:  🌱🌱🥀  (only 3 years)
  Weather
   J F M A M J J A S O N D
   ▂ ▂ ▁ ▁ ▃ ▆ █ █ ▇ ▅ ▃ ▂
   dry ░  normal ▒  wet █
  What we don't know yet
   Prices change. Data is for the
   town, not your field.
  [ Ask the MAO ]
```
- **Contents, top to bottom:**
  1. Rotation header (pictures, names, rank).
  2. **Why this:** two or three reason sentences from `main_reasons`.
  3. **The good:** short bullet list with icons (saves water, adds nitrogen, breaks pests).
  4. **The risk:** short bullet list (needs storage, price swings, labor).
  5. **Past years:** icon rows for all years and for El Niño years, with "Only 3 El Niño years are in the data, so this is not certain yet."
  6. **Weather picture:** 12 monthly bars colored dry / normal / wet, no axis numbers.
  7. **What we don't know yet:** data gaps in plain words (prices change, satellite data covers the town, not your field).
  8. **Ask the MAO** block and the disclaimer.

### P14 El Niño (climate alert)
```
  ← 🏠
        [sun picture]
       EL NIÑO IS HERE
  Less rain than usual is likely.

  What happened before
   Rice → Rice      🥀🥀🌱
   Rice → Mungbean  🌱🌱🥀
   (only 3 El Niño years in data)

  What to do now
   ☐ Ask about canal schedule
   ☐ Consider a low-water crop
   ☐ Talk to the MAO
  [ Get advice for next crop ▸ ]
```
- **Contents:** status picture and word in three states (El Niño / Normal / La Niña) · "What this means" in one sentence · "What happened before": each rotation's icon row for past El Niño years, with the few-years caution · "What to do now": 3 to 4 checklist items · button **Get advice for next crop** → P9 · disclaimer.
- **Data:** ONI phase, `elnino` frequencies.

### P15 Settings
```
  ← 🏠   Settings

  Language      [English|Filipino]
  Read aloud    [Off|On tap|Auto]
                [ Test voice ]
  Voice speed   [Slow|Normal]
  Location      Guimba          ▸
  Harvest reminders        [ on ]
  For technicians               ▸
  About and data                ▸

  [ Clear my data ]
```
- **Contents:**
  1. **Language:** English / Filipino.
  2. **Read aloud (voice):** Off / When I tap 🔊 / Automatic on each page. A "Test voice" button. If the phone has no voice for the chosen language, a plain note says so and that English voice will be used.
  3. **Voice speed:** Slow / Normal (shown only when voice is on).
  4. **Location:** current place → P2.
  5. **Harvest reminders:** on / off.
  6. **For technicians** → P16.
  7. **About and data** → P17.
  8. **Clear my data** (plantings and answers), with confirm.

### P16 For technicians (English only)
```
  ← 🏠   For technicians

  Baseline 2015–2025 (11 yrs)
  Rotation      x/n   95% CI
  rice_mungbean 2/11  5–48%
  rice_rice     6/11  28–79%
  …
  Confidence: Medium
   limited by: sample size
  Data quality: bias, RMSE, r,
   years per variable, missing %
  Monthly z-scores (table)
  Export date · schema_version
```
- **Contents:** baseline period and its limits · per-rotation table with frequencies and Wilson intervals (`ci_low`, `ci_high`), ranges on income and water · the four confidence factors and which one set the level · `data_quality` block (bias, RMSE, r, years per variable, missing %) · monthly z-score table · data export date and `schema_version`.

### P17 About and data
```
  ← 🏠   About and data

  Ani helps you follow your crop
  and compare what to plant next.

  Data: NASA POWER, GPM, SMAP,
  MODIS, SRTM, GRACE, SoilGrids,
  NOAA ONI

  Satellite data covers your town,
  not your exact field.

  Advice only. Ask your local
  agriculture office.
  Version 0.1
```
- **Contents:** what Ani does in two sentences · data sources with credit (NASA POWER, GPM, SMAP, MODIS, SRTM, GRACE, SoilGrids, NOAA ONI) · "Satellite data covers your town, not your exact field" · full disclaimer · app version.

## Voice (optional)
- Three modes in Settings: **Off**, **On tap**, **Automatic**. With Off, no 🔊 button appears anywhere and nothing depends on sound.
- When on: 🔊 in the top bar reads the page; each result card and each Detail block has its own 🔊; the part being read is outlined; reading stops on navigation.
- Voice follows the app language (`fil-PH` or English), with English voice as fallback.
- Default on first install: **On tap** (recommended; see open decisions).

## Language and localization
- Flutter `gen_l10n` with ARB files: `app_en.arb` is the source of truth, `app_fil.arb` the translation (replaces the planned `l10n/phrases_fil.dart`). Missing keys fall back to English, and a test fails if a key is missing.
- Screen text and spoken text are separate keys; sentences use placeholders and plural rules, never words joined in code.
- Layouts allow about 40% longer text and wrap instead of truncating.
- Dates, numbers and money go through `intl`.
- A native speaker reviews the Filipino file for plain farmer vocabulary. Words banned on farmer pages in any language: z-score, percent, probability, baseline, ENSO, ONI.

## Built to grow beyond Nueva Ecija
Nothing here is built now; these choices keep the door open.

| Today | Design choice that scales |
|---|---|
| 3 municipalities | P2 is a list driven by bundled data. Later: country → province → town, or GPS. |
| Rice, onion, mungbean, corn | Crop id → icon + localized name, from data. No crop named in page code. |
| Tag-ulan / Tag-araw | Seasons declared per region in data. |
| NIA canal / well / rain | Generic ids (`canal`, `well`, `rainfed`) with a regional label. |
| MAO / PhilRice | Per-region `advisor_name`. Base text: "your local agriculture office". |
| ₱, hectares | Currency and units from region and locale. |
| El Niño banner | Generic "climate alert" slot. |
| English + Filipino | One ARB file per new language; start-aligned layouts for right-to-left later. |

This needs a small `region` block (advisor name, currency, seasons) in `schema/muni.schema.json`.

## Showing uncertainty
- **Risk** uses traffic-light colors. **Confidence** uses a separate three-dot meter, so a card never shows two opposite traffic lights. This differs from `docs/plan.md`.
- With an 11-year baseline, sample size tops out at Medium and confidence is the lowest factor, so **no card can show "Sure"**. P12 says why once; the useful difference is ●●○ versus ●○○.

## Build order for the Flutter team
1. Localization setup and Settings store (language, voice mode).
2. Shared widgets: `ChoiceCard`, `StepScaffold`, `IconCount`, `RiskBadge`, `ConfidenceDots`, `SpeakButton` (renders nothing when voice is off).
3. Hours 0–4: P1–P3, P9–P11 on mock JSON. Hours 4–16: P4–P8. Hours 16–28: P12, P15, voice. Hours 28–40: P13, P14, P16, P17.

## Verification
- **Localization:** every key exists in both ARB files; each page's widget test runs in both languages and at the largest font with no overflow.
- **Voice off:** every widget test passes with voice Off and finds no 🔊; a full flow completes with the phone muted.
- **Gate 13:** each page test checks the top bar, that every choice has a picture and label, that risk color matches the data, and that "X of Y years" matches the JSON.
- **Gate 14 (manual):** airplane mode; with voice on, every result card is read in Filipino and English; fallback works when the Filipino voice is missing.
- **Gate 15 (usability):** five tasks, in Filipino, voice off, unaided: set Guimba; add rice planted last week; say when harvest is expected; get advice for save water + low risk; explain which rotation was suggested and how sure the app is. Script goes into `docs/manual_checklist.md`.

## Open decisions for the team
1. Voice default on first install: **On tap** (recommended, since many users read little) or **Off**.
2. Confidence as dots instead of a second traffic light (recommended).
3. Location in first-run setup (recommended).
4. Adding the `region` block to the JSON contract now (recommended; small backend change).
5. A clickable HTML mockup for testing wording with a farmer before Flutter work. Not included unless asked.
