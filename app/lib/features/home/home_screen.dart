import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../core/dryness.dart' show dryRank;
import '../../data/bundle.dart';
import '../../data/planner_profile.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/theme.dart';
import '../labels.dart';
import '../recommend/recommend_flow.dart';
import '../recommend/recommend_labels.dart';
import 'settings_sheet.dart';

/// Start screen (doc Fig. 2): El Niño outlook, dryness banner, heat-safety
/// strip, the planner CTA, the tracked-crop summary and alerts.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final town = state.town;
    final bundle = state.bundle;
    final saved = state.plannerProfile;

    return SafeArea(
      child: ListView(
        key: const ValueKey('home-list'),
        padding: const EdgeInsets.fromLTRB(AniSpacing.screen, AniSpacing.sm, AniSpacing.screen, AniSpacing.xxl),
        children: [
          Row(
            children: [
              Expanded(child: Eyebrow(l.appTitle)),
              IconButton(
                key: const ValueKey('home-settings'),
                tooltip: l.settingsTitle,
                icon: const Icon(Icons.settings_outlined, color: AniColors.olive),
                onPressed: () => showSettingsSheet(context),
              ),
            ],
          ),
          Text(
            town == null ? '' : l.townName(town),
            key: const ValueKey('home-town'),
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AniSpacing.lg),
          if (bundle != null) ...[
            _EnsoCard(enso: bundle.enso),
            const SizedBox(height: AniSpacing.md),
            _DrynessBanner(dryness: bundle.dryness),
            const SizedBox(height: AniSpacing.md),
            _HeatStrip(heat: bundle.heat),
            const SizedBox(height: AniSpacing.xl),
          ],
          PrimaryButton(
            key: const ValueKey('home-cta'),
            label: l.homeCta,
            icon: Icons.eco_outlined,
            onPressed: () => openRecommendFlow(context),
          ),
          if (state.hasRecommendation && saved != null) ...[
            const SizedBox(height: AniSpacing.md),
            _LastRecommendation(saved: saved),
          ],
          const SizedBox(height: AniSpacing.xl),
          const _TrackedCropCard(),
          const SizedBox(height: AniSpacing.md),
          const _AlertsCard(),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ helpers

/// Signed fixed-point number, e.g. "+2.2" / "-1.45".
String _signed(double x, int digits) => '${x >= 0 ? '+' : ''}${x.toStringAsFixed(digits)}';

/// "42" for whole numbers, else one decimal.
String _degrees(double x) => x == x.roundToDouble() ? x.toStringAsFixed(0) : x.toStringAsFixed(1);

/// Rank sentence for `dryness.latest`, localized. The rank is recomputed with
/// [dryRank] against the same calendar month in `dryness.monthly` (the
/// pipeline's `dry_rank` / `dry_n`) and phrased like `rank_text`: "driest r
/// of n" when D >= 0, "wettest (n - r + 1) of n" otherwise. Falls back to the
/// bundle's own Filipino sentence if the month is missing from the series.
String? drynessRankSentence(AppLocalizations l, Dryness dryness) {
  final latest = dryness.latest;
  final m = latest.month.length >= 7 ? int.tryParse(latest.month.substring(5, 7)) : null;
  final others = [
    for (final p in dryness.monthly)
      if (p.monthOfYear == m && p.month != latest.month) p.d,
  ];
  final present = dryness.monthly.any((p) => p.month == latest.month);
  if (!present || others.isEmpty) return latest.rank;
  final r = dryRank(latest.d, others);
  return latest.d >= 0 ? l.drynessRank(r.rank, r.n) : l.drynessRankWet(r.n - r.rank + 1, r.n);
}

// ------------------------------------------------------------------ El Niño

class _EnsoCard extends StatelessWidget {
  const _EnsoCard({required this.enso});

  final Enso enso;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final jas = enso.jas;
    final tagColor = enso.isElNino ? AniColors.statusDelikado : AniColors.olive;
    return AniCard(
      key: const ValueKey('home-enso'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(Icons.wb_sunny_outlined, color: tagColor),
          ),
          const SizedBox(width: AniSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow('${l.homeOutlookTitle} · ${enso.comingSeason}'),
                const SizedBox(height: AniSpacing.xs),
                Text(
                  enso.isElNino ? l.elNinoExpected : l.ensoTagName(enso.tag),
                  key: const ValueKey('home-enso-headline'),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AniSpacing.sm),
                Wrap(
                  spacing: AniSpacing.sm,
                  runSpacing: AniSpacing.sm,
                  children: [
                    AniPill(l.ensoTagName(enso.tag), color: tagColor),
                    if (jas != null)
                      AniPill(
                        l.ensoJasValue(_signed(jas, 1)),
                        key: const ValueKey('home-enso-jas'),
                        color: AniColors.muted,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ dryness

class _DrynessBanner extends StatelessWidget {
  const _DrynessBanner({required this.dryness});

  final Dryness dryness;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final latest = dryness.latest;
    final fg = drynessColor(latest.label);
    final rank = drynessRankSentence(l, dryness);
    return Container(
      key: const ValueKey('home-dryness'),
      decoration: BoxDecoration(
        color: drynessBgColor(latest.label),
        borderRadius: AniRadius.card,
        border: Border.all(color: fg.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsets.all(AniSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.water_drop_outlined, color: fg),
          const SizedBox(width: AniSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow('${l.drynessTitle} · ${latest.month}', color: fg),
                const SizedBox(height: AniSpacing.xs),
                Wrap(
                  spacing: AniSpacing.sm,
                  runSpacing: AniSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      l.drynessLabelName(latest.label),
                      key: const ValueKey('home-dryness-label'),
                      style: theme.textTheme.headlineSmall?.copyWith(color: fg),
                    ),
                    AniPill(
                      l.drynessDValue(_signed(latest.d, 2)),
                      key: const ValueKey('home-dryness-d'),
                      color: fg,
                    ),
                  ],
                ),
                if (rank != null) ...[
                  const SizedBox(height: AniSpacing.xs),
                  Text(
                    rank,
                    key: const ValueKey('home-dryness-rank'),
                    style: theme.textTheme.bodyMedium?.copyWith(color: AniColors.ink),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ heat

/// People-safety advice only; never feeds the planner (doc requirement).
class _HeatStrip extends StatelessWidget {
  const _HeatStrip({required this.heat});

  final HeatInfo heat;

  static const _dangerLabels = {'danger', 'extreme danger'};

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    HeatCategory? danger;
    for (final c in heat.indexCategoriesC) {
      if (_dangerLabels.contains(c.label)) {
        danger = c;
        break;
      }
    }
    return AniCard(
      key: const ValueKey('home-heat'),
      padding: const EdgeInsets.symmetric(horizontal: AniSpacing.lg, vertical: AniSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.thermostat_outlined, color: AniColors.gold),
          const SizedBox(width: AniSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(l.heatSafetyTitle),
                const SizedBox(height: AniSpacing.xs),
                if (danger != null)
                  Text(
                    l.homeHeatDangerFrom(l.heatCategoryName(danger.label), _degrees(danger.from)),
                    style: theme.textTheme.bodyMedium,
                  ),
                Text(
                  l.workEarly,
                  key: const ValueKey('home-heat-advice'),
                  style: theme.textTheme.titleSmall?.copyWith(color: AniColors.statusDelikado),
                ),
                if (heat.indexCategoriesC.isNotEmpty) ...[
                  const SizedBox(height: AniSpacing.sm),
                  Wrap(
                    spacing: AniSpacing.xs,
                    runSpacing: AniSpacing.xs,
                    children: [
                      for (final c in heat.indexCategoriesC)
                        AniPill(
                          '${l.heatCategoryName(c.label)} ${_degrees(c.from)}${c.to == null ? '+' : '–${_degrees(c.to!)}'}°C',
                          color: _dangerLabels.contains(c.label) ? AniColors.statusDelikado : AniColors.gold,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: AniSpacing.sm),
                Text(
                  l.heatSafetyNote,
                  style: theme.textTheme.bodySmall?.copyWith(color: AniColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ last recommendation

class _LastRecommendation extends StatelessWidget {
  const _LastRecommendation({required this.saved});

  final SavedPlannerProfile saved;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final town = saved.town;
    return AniCard(
      key: const ValueKey('home-last-rec'),
      padding: const EdgeInsets.all(AniSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Eyebrow(l.homeLastRecommendationTitle),
          const SizedBox(height: AniSpacing.xs),
          Text(
            l.resultSubtitle(
              town == null ? saved.profile.muni : l.townName(town),
              l.waterLevelName(saved.profile.water),
            ),
            key: const ValueKey('home-last-rec-summary'),
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AniSpacing.sm),
          OutlinedButton.icon(
            key: const ValueKey('home-last-rec-open'),
            onPressed: () => openLastRecommendation(context),
            icon: const Icon(Icons.history, size: 20),
            label: Text(l.homeLastRecommendation),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ tracked crop, alerts

class _TrackedCropCard extends StatelessWidget {
  const _TrackedCropCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AniCard(
      key: const ValueKey('home-crops'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(l.homeTrackedTitle),
          const SizedBox(height: AniSpacing.sm),
          Row(
            children: [
              const Icon(Icons.grass_outlined, color: AniColors.sand),
              const SizedBox(width: AniSpacing.sm),
              Expanded(
                child: Text(
                  l.homeTrackedEmpty,
                  key: const ValueKey('home-crops-empty'),
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AniSpacing.xs),
          Text(l.homeTrackedHint, style: theme.textTheme.bodyMedium?.copyWith(color: AniColors.muted)),
        ],
      ),
    );
  }
}

class _AlertsCard extends StatelessWidget {
  const _AlertsCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AniCard(
      key: const ValueKey('home-alerts'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(l.alertsTitle),
          const SizedBox(height: AniSpacing.sm),
          Row(
            children: [
              const Icon(Icons.notifications_none_outlined, color: AniColors.sand),
              const SizedBox(width: AniSpacing.sm),
              Expanded(
                child: Text(
                  l.alertsEmpty,
                  key: const ValueKey('home-alerts-empty'),
                  style: theme.textTheme.bodyMedium?.copyWith(color: AniColors.muted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
