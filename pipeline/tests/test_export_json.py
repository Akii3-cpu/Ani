"""Tests for export_json.py: schema, size, and planner parity (CSV vs exported JSON)."""

import json

import numpy as np
import pandas as pd

from pipeline import planner as P
from pipeline.export_json import build, rank_text, risk_frame
from pipeline.tests.test_planner import RISK


def _inputs():
    idx = pd.date_range("2001-01-01", "2025-12-31", name="date")
    rng = np.random.default_rng(0)
    doy = idx.dayofyear.values
    daily = pd.DataFrame({"T2M_MAX": 32 + 3 * np.sin(2 * np.pi * (doy - 30) / 365),
                          "T2M_MIN": 22 + 2 * np.sin(2 * np.pi * (doy - 30) / 365),
                          "PRECTOTCORR": np.where(rng.random(len(idx)) < 0.3, rng.gamma(0.8, 15, len(idx)), 0.0),
                          "ET0": 4.5}, index=idx)
    mi = pd.date_range("2001-01-01", "2025-12-01", freq="MS", name="month")
    monthly = pd.DataFrame({"D": rng.normal(0, 1, len(mi)), "label": "normal", "dry_rank": 3, "dry_n": 25},
                           index=mi)
    monthly.iloc[-1, monthly.columns.get_loc("D")] = -1.4
    soil_row = pd.Series({"town_lat": 15.7153, "town_lon": 120.9039, "awc_mm_per_m_0_30": 104.0,
                          "awc_mm_per_m_0_60": 104.0, "awc_mm_per_m_0_100": 104.0})
    enso = pd.DataFrame({"dry_season": ["2015-16", "2025-26", "2026-27"], "jas": [1.7, -0.3, 2.2],
                         "tag_jas": ["el_nino", "neutral", "el_nino"],
                         "tag_episode": ["el_nino", "neutral", "pending"]})
    fao = {"fao_l_ini": 20, "fao_l_dev": 30, "fao_l_mid": 30, "fao_l_late": 20}
    crops = {c: {"duration_days": (100.0,) * 3, "sow_day": (30, 15, 45), "root_depth_m": (0.8,) * 3,
                 "p": (0.5,) * 3, "kc_ini": (0.4,) * 3, "kc_mid": (1.05,) * 3, "kc_end": (0.5,) * 3,
                 "t_base_c": (10.0,) * 3, **{k: (float(v),) * 3 for k, v in fao.items()}}
             for c in P.NAME}
    crops["rice"]["t_crit_c"] = (35.0, 33.7, 35.0)
    outcomes = pd.DataFrame({"crop": ["rice"], "water": ["full"], "heat_days": [0]})
    return daily, monthly, soil_row, enso, crops, outcomes


def test_schema_and_json_round_trip():
    daily, monthly, soil_row, enso, crops, outcomes = _inputs()
    doc = build("munoz", daily, monthly, soil_row, None, RISK, outcomes, enso, crops, None)
    s = json.dumps(doc, ensure_ascii=False)
    back = json.loads(s)
    assert set(back) == {"meta", "enso", "dryness", "crops", "risk", "planner", "tracker", "heat"}
    assert back["enso"]["coming_season"] == "2026-27" and back["enso"]["tag"] == "el_nino"
    assert all(p["tag"] != "pending" for p in back["enso"]["past"])
    assert set(back["risk"]) == {"limited_2", "full"} and set(back["tracker"]) == set(P.NAME)
    assert back["tracker"]["rice"]["t_crit"] == 35 and back["tracker"]["maize"]["t_crit"] is None
    assert len(s) < 200_000


def test_wet_month_rank_reads_wettest():
    assert rank_text(-1.4, 24, 25) == "pinakabasa: ika-2 sa 25 na taon"
    assert rank_text(1.2, 3, 25) == "pinakatuyo: ika-3 sa 25 na taon"


def test_planner_gives_identical_cards_from_csv_and_from_json():
    daily, monthly, soil_row, enso, crops, outcomes = _inputs()
    doc = json.loads(json.dumps(build("munoz", daily, monthly, soil_row, None, RISK, outcomes,
                                      enso, crops, None)))
    risk_j, hs_j = risk_frame(doc)
    for water in ("limited_2", "full"):
        for pr in (["risk", "income", "water"], ["income", "risk", "pest"], ["water", "soil"]):
            prof = lambda: P.Profile("munoz", water, ["rice", "rice"], set(), False, pr)
            a = P.plan(prof(), RISK, {}, True)
            b = P.plan(prof(), risk_j, hs_j, True)
            assert [c["crop"] for c in a["cards"]] == [c["crop"] for c in b["cards"]]
            assert [c["score"] for c in a["cards"]] == [c["score"] for c in b["cards"]]