# Data record

One row per downloaded dataset. Raw files live in `pipeline/data/raw/` (gitignored) and in the team's shared Drive folder. How to download each one: [`docs/data_download_guide.md`](../../docs/data_download_guide.md).

| Dataset | Product / short name | Version | Variables | Area (points or polygons) | Dates | Downloaded on | By | Scale factor / no-data code | Notes |
|---|---|---|---|---|---|---|---|---|---|
| SMAP L4 soil moisture | SPL4SMGP | 008 | sm_rootzone, sm_surface | 3 points | 2015-03-31 – | | | | DOI 10.5067/T5RUATAQREF8 |
| MODIS NDVI | MOD13Q1 | 061 | NDVI, EVI, pixel_reliability | 3 polygons | 2015-01-01 – 2025-12-31 | | | | |
| MODIS ET | MOD16A2GF (or MOD16A2) | 061 | ET_500m | 3 polygons | 2015-01-01 – 2025-12-31 | | | | |
| SRTM elevation | SRTMGL1_NC | 003 | elevation | 3 polygons | 2000 | | | | |
| NASA POWER daily | POWER (AG community) | | T2M_MAX, T2M_MIN, PRECTOTCORR, RH2M, WS2M, ALLSKY_SFC_SW_DWN | 3 points | 2015-01-01 – 2025-12-31 | | | −999 | |
| GPM IMERG | GPM_3IMERGDF (Final) | 07 | precipitation | 3 boxes (Giovanni) | 2015-01-01 – 2025-12-31 | | | | |
| GRACE/GRACE-FO | JPL mascon CRI | RL06.x | water storage anomaly | global file | 2002 – | | | | |
| SoilGrids | SoilGrids 2.0 REST | 2.0 | clay, sand, silt, soc, phh2o, cec, bdod (0–30 cm) | 3 points | — | | | | |
| ONI | NOAA CPC oni.ascii.txt | | ONI anomaly | — | 1950 – | | | | |
| Boundaries | HDX cod-ab-phl (admin 3) | | polygons | 3 municipalities | — | | | | |
