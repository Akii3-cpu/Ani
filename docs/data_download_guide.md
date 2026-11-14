# How to Download the NASA and Supporting Data for Ani

A step-by-step guide for the data team. Follow the steps in order. No coding is needed except in step 9 (optional).

**What you are downloading:** climate, soil moisture, vegetation, elevation and groundwater data for **3 municipalities in Nueva Ecija**: Guimba, Science City of Muñoz and Bongabon.

**Time needed:** about 1–2 hours of clicking. AppEEARS jobs then run on NASA's side for several hours, so start steps 1–4 first.

---

## Before you start: rules

1. **Never commit raw downloads to git.** Save them under `pipeline/data/raw/<dataset>/`. That folder is already ignored by `.gitignore`. Share raw files with teammates through our shared Drive folder.
2. **Do not download global files.** We only need 3 small areas. Every step below cuts the data to our area before downloading.
3. **After each download, add one row to `pipeline/data/README.md`** (product, version, dates, area, download date, your name). Then tick it in the checklist at the end of this guide.
4. If anything looks different from this guide, take a screenshot and post it in the group chat before guessing.

## Split the work (suggested)

| Person | Steps |
|---|---|
| Groupmate A | 1, 2, 3, 4, 5 (account, boundaries, AppEEARS: SMAP, MODIS, SRTM) |
| Groupmate B | 1, 6, 7, 8, 9, 10 (POWER, GPM, GRACE, SoilGrids, ONI) |

Both of you need step 1.

---

## Step 1: Create a NASA Earthdata account (everyone, 5 min)

1. Go to **https://urs.earthdata.nasa.gov** → **Register**.
2. Fill in the form. For "Study area" you can pick *Agriculture*.
3. Confirm your email.
4. Keep your username and password private. Never paste them into code that goes to GitHub.

**If a download later fails with error 401 or 403:** sign in at urs.earthdata.nasa.gov → **Applications → Authorized Apps** → approve the data center named in the error (e.g., NSIDC, LP DAAC, GES DISC, PO.DAAC).

---

## Step 2: Get the municipality boundaries (Groupmate A, 15 min)

AppEEARS needs the outline (polygon) of each municipality.

1. Go to **https://data.humdata.org** and search **"Philippines subnational administrative boundaries"** (dataset `cod-ab-phl`).
2. Download the **municipality level (admin level 3)** file, as **GeoJSON** or **shapefile (zip)**.
3. Open **https://mapshaper.org** (free, in the browser) and drag the file in.
4. Keep only our 3 municipalities. In mapshaper, click **Console** and type the command below. Check the column name first by clicking a shape: it may be `ADM3_EN`, and Muñoz may be written as "Science City of Muñoz" or "Munoz".
   ```
   -filter '["Guimba","Science City of Muñoz","Bongabon"].indexOf(ADM3_EN) > -1'
   ```
5. Click **Simplify** and drag to about 10% (AppEEARS rejects very detailed shapes).
6. **Export → GeoJSON**. Save it as `pipeline/data/boundaries/ani_3_municipalities.geojson`.
   - This file is small, so it **can** be committed.
7. Also write down each municipality's center (click the shape in mapshaper or use the console command `-points centroid` then export as CSV). Use these coordinates in steps 3, 6 and 9.

Approximate centers, if you need them before step 2 is done (replace them later with the real centroids):

| ID | Latitude | Longitude |
|---|---|---|
| Guimba | 15.66 | 120.77 |
| Munoz | 15.72 | 120.90 |
| Bongabon | 15.64 | 121.15 |

---

## Step 3: SMAP soil moisture through AppEEARS (Groupmate A, 15 min + waiting)

**Product:** `SPL4SMGP` version **008**, "SMAP L4 Global 3-hourly 9 km EASE-Grid Surface and Root Zone Soil Moisture Geophysical Data". DOI 10.5067/T5RUATAQREF8.

⚠️ Do **not** use "SMAP L4 ... Carbon Net Ecosystem Exchange" (`SPL4CMDL`). It has no soil moisture.

1. Go to **https://appeears.earthdatacloud.nasa.gov** → **Sign In** (Earthdata login).
2. **Extract → Point Samples → Start a new request.**
3. **Sample name:** `ani_smap_l4`
4. **Points:** click *Add Point* three times, or upload a CSV like this (use your step 2 centroids):
   ```
   ID,Category,Latitude,Longitude
   Guimba,municipality,15.66,120.77
   Munoz,municipality,15.72,120.90
   Bongabon,municipality,15.64,121.15
   ```
5. **Start date:** 03-31-2015. **End date:** today.
6. **Layers:** type `SPL4SMGP` in the search box → pick **SPL4SMGP.008** → add the layers **`sm_rootzone`** and **`sm_surface`** (and `sm_rootzone_pctl` if it is listed).
7. **Output:** CSV → **Submit**.
8. Check progress under **Explore**. When the status is *Done*, download the CSV files into `pipeline/data/raw/smap/`.

**If `SPL4SMGP.008` is not in the list:** stop and post a screenshot in the group chat. Do not download from the "Data Access" button on the Earthdata page (that is the global archive).

**Expect:** values every 3 hours, so the CSV is long. Soil moisture values should be between about **0.05 and 0.6** (m³/m³).

---

## Step 4: MODIS vegetation (NDVI) and evapotranspiration through AppEEARS (Groupmate A, 15 min + waiting)

We want the **average over each municipality**, so this is an **Area Sample**.

1. In AppEEARS: **Extract → Area Samples → Start a new request.**
2. **Sample name:** `ani_modis`
3. **Upload** `ani_3_municipalities.geojson` from step 2.
4. **Start date:** 01-01-2001. **End date:** 12-31-2025.
5. **Layers:**
   - Search `MOD13Q1` → pick **MOD13Q1.061** (250 m, 16-day) → add **`_250m_16_days_NDVI`**, **`_250m_16_days_EVI`** and **`_250m_16_days_pixel_reliability`**.
   - Search `MOD16A2` → pick **MOD16A2GF.061** (gap-filled, preferred) or **MOD16A2.061** → add **`ET_500m`**.
6. **Output:** File format **GeoTIFF**, Projection **Geographic (WGS84)** → **Submit**.
7. When *Done*, download:
   - the **Statistics CSV** files (one row per date per municipality, with the mean). **These are the files we use most.**
   - the GeoTIFFs only if you have space. Put everything in `pipeline/data/raw/modis/`.

**Expect:**
- NDVI between −0.2 and 1. If the numbers look like 7000, they still need the scale factor (× 0.0001). Note this in the README row.
- ET has a scale factor of 0.1 and very large numbers (32,761 and above) mean "no data", not real values.
- Many cloudy dates in June–October. That is normal; the pipeline handles it.

---

## Step 5: SRTM elevation through AppEEARS (Groupmate A, 10 min + waiting)

1. AppEEARS: **Extract → Area Samples → Start a new request.**
2. **Sample name:** `ani_srtm`
3. **Upload** the same `ani_3_municipalities.geojson`.
4. **Dates:** any range that includes the year 2000 (SRTM is a single snapshot from February 2000), e.g., 02-01-2000 to 02-28-2000.
5. **Layers:** search `SRTM` → pick **SRTMGL1_NC.003** (30 m) → add the elevation layer.
6. **Output:** GeoTIFF, Geographic (WGS84) → **Submit**.
7. Download into `pipeline/data/raw/srtm/`.

**Expect:** elevations of roughly 20–100 m in the lowland parts. Bongabon's eastern side is hilly, so some values will be much higher.

---

## Step 6: NASA POWER daily weather (Groupmate B, 15 min, no login)

POWER gives daily temperature, rain, humidity, wind and sunlight. It is the most important dataset.

**Option A (website):**
1. Go to **https://power.larc.nasa.gov/data-access-viewer/**
2. **User community:** *Agroclimatology*. **Temporal average:** *Daily*.
3. Click the map or type the latitude/longitude of **Guimba** (from step 2).
4. **Dates:** 01/01/2001 → 12/31/2025. **Output format:** CSV.
5. **Parameters** (use the search box): 
   - Temperature at 2 m: **Maximum** (`T2M_MAX`) and **Minimum** (`T2M_MIN`)
   - **Precipitation Corrected** (`PRECTOTCORR`)
   - **Relative Humidity at 2 m** (`RH2M`)
   - **Wind Speed at 2 m** (`WS2M`)
   - **All Sky Surface Shortwave Downward Irradiance** (`ALLSKY_SFC_SW_DWN`)
6. **Submit** → download the CSV → save as `pipeline/data/raw/power/power_guimba.csv`.
7. Repeat for **Munoz** and **Bongabon**.

**Option B (one link per municipality):** paste this into your browser (change the latitude/longitude), and save the result as CSV:
```
https://power.larc.nasa.gov/api/temporal/daily/point?parameters=T2M_MAX,T2M_MIN,PRECTOTCORR,RH2M,WS2M,ALLSKY_SFC_SW_DWN&community=AG&latitude=15.66&longitude=120.77&start=20010101&end=20251231&format=CSV
```

**Expect:** about 9,130 rows (one per day). Tmax roughly 25–38 °C; rain 0 to a few hundred mm on typhoon days. **−999** means missing.

These 3 CSVs are small (around 1 MB each). After cleaning, the pipeline saves a copy to `pipeline/data/processed/`, which **is** committed.

---

## Step 7: GPM IMERG rainfall through Giovanni (Groupmate B, 20 min)

AppEEARS may not have GPM, so we use NASA **Giovanni**, which makes an area-averaged time series without downloading big files.

1. Go to **https://giovanni.gsfc.nasa.gov** → sign in with Earthdata.
2. **Select plot:** *Time Series, Area-Averaged*.
3. **Dates:** 2001-01-01 to 2025-12-31.
4. **Region:** draw a small box around **one** municipality, or type its bounding box (west, south, east, north). For Guimba, for example, about `120.70,15.60,120.85,15.72`. Get the real boxes from step 2.
5. **Variables:** search **IMERG** → pick **"Daily precipitation (IMERG Final run, version 07)"** (product `GPM_3IMERGDF`, the *Final* run, not Early or Late).
6. **Plot data** → when the chart appears, click **Downloads → CSV**.
7. Save as `pipeline/data/raw/gpm/gpm_<municipality>.csv`. Repeat for the other 2 municipalities.

**If Giovanni limits the date range:** split it into two requests (2001–2012, 2013–2025).

**Expect:** daily rain in mm/day, mostly 0 in January–April, high values in July–September.

---

## Step 8: GRACE / GRACE-FO groundwater (Groupmate B, 15 min)

GRACE is very coarse (province scale), so we only need the **long-term trend**. The mascon data comes as **one file with all months**.

1. Go to **https://search.earthdata.nasa.gov** and search **"JPL GRACE GRACE-FO mascon CRI"**.
2. Pick the latest **JPL Tellus GRACE/GRACE-FO Mascon CRI** release (RL06.x, the newest version shown).
3. Download the single **NetCDF (.nc)** grid file (a few hundred MB). Save it in `pipeline/data/raw/grace/`.
4. The pipeline will cut out the Nueva Ecija pixels. You do not need to open the file.

**If you are unsure which file to pick:** post a screenshot of the search results in the group chat.

---

## Step 9: SoilGrids soil properties (Groupmate B, 10 min, no login)

1. Paste this link into your browser (one per municipality, change `lon` and `lat`):
   ```
   https://rest.isric.org/soilgrids/v2.0/properties/query?lon=120.77&lat=15.66&property=clay&property=sand&property=silt&property=soc&property=phh2o&property=cec&property=bdod&depth=0-5cm&depth=5-15cm&depth=15-30cm&value=mean
   ```
2. Save the page as `pipeline/data/raw/soilgrids/soil_<municipality>.json` (browser: right click → Save as).
3. **Wait at least 15 seconds between requests.** The service allows only about 5 requests per minute.
4. These files are tiny. The cleaned version will be committed.

**If the service is down or returns an error:** use the map at **https://soilgrids.org**, click each municipality and copy the values into a CSV with columns `municipality, depth, clay, sand, silt, soc, ph, cec, bdod`.

**Note on units:** SoilGrids stores values multiplied by a factor (e.g., clay in g/kg, pH × 10). The JSON lists the factor for each property; write it in the README row.

---

## Step 10: El Niño / La Niña index, ONI (Groupmate B, 2 min, no login)

1. Open **https://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt**
2. Save the page as `pipeline/data/raw/oni/oni.ascii.txt`.

**Expect:** a table with columns season (e.g., `DJF`), year, total, anomaly. El Niño = anomaly ≥ +0.5 for several seasons in a row.

---

## After all downloads: quick checks (Task 3 test gate)

Before telling the team "data is ready", check each dataset:

| Check | How |
|---|---|
| Dates are continuous | First and last date match the request; no big jumps |
| Units make sense | Temperature in °C, rain in mm/day, soil moisture 0–0.6, NDVI −0.2–1 after scaling |
| Missing values are marked | Note which code means "no data" (−999, 32,761+, blank) |
| No impossible values | No negative rain, no Tmax above 45 °C |
| All 3 municipalities present | Every dataset has Guimba, Munoz and Bongabon |
| Recorded | A row exists in `pipeline/data/README.md` |

The pipeline code will repeat these checks automatically later, but catching problems now saves hours.

---

## Checklist

| # | Dataset | Who | Submitted | Downloaded | Checked | README row |
|---|---|---|---|---|---|---|
| 1 | Earthdata accounts | all | | | | — |
| 2 | Boundaries (HDX) | A | | | | |
| 3 | SMAP SPL4SMGP.008 | A | | | | |
| 4 | MODIS MOD13Q1 + MOD16A2(GF) | A | | | | |
| 5 | SRTM SRTMGL1_NC.003 | A | | | | |
| 6 | NASA POWER daily | B | | | | |
| 7 | GPM IMERG Final daily | B | | | | |
| 8 | GRACE/GRACE-FO mascon | B | | | | |
| 9 | SoilGrids | B | | | | |
| 10 | ONI | B | | | | |

## Common problems

| Problem | Fix |
|---|---|
| 401 / 403 error | Earthdata profile → Applications → Authorized Apps → approve the data center |
| AppEEARS job stuck in "pending" or "processing" | Normal for hours. Check again later; do not resubmit |
| AppEEARS rejects the GeoJSON | Simplify more in mapshaper; make sure it has only 3 shapes |
| A product version in this guide is not listed | Use the newest version shown and write it in the README row |
| File is huge (GBs) | You probably downloaded global data. Delete it and use the subset steps above |

Product names and versions in this guide were current when it was written. Websites change, so if a button or name differs, follow the closest match and note it in the README row.
