import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../data/bundle.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/theme.dart';
import '../labels.dart';
import 'settings_sheet.dart';

/// Phase 1 home placeholder: proves the town bundle loaded.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final town = state.town;
    final bundle = state.bundle;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AniSpacing.screen),
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
            town?.displayName ?? '',
            key: const ValueKey('home-town'),
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AniSpacing.lg),
          if (bundle != null) ..._bundleCards(context, l, bundle),
        ],
      ),
    );
  }

  List<Widget> _bundleCards(BuildContext context, AppLocalizations l, AniBundle b) {
    final theme = Theme.of(context);
    final enso = b.enso;
    final jas = enso.jas;
    final latest = b.dryness.latest;
    final dryColor = drynessColor(latest.label);
    return [
      AniCard(
        key: const ValueKey('home-enso'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow('${l.homeOutlookTitle} · ${enso.comingSeason}'),
            const SizedBox(height: AniSpacing.sm),
            Wrap(
              spacing: AniSpacing.sm,
              runSpacing: AniSpacing.sm,
              children: [
                AniPill(
                  l.ensoTagName(enso.tag),
                  color: enso.isElNino ? AniColors.statusDelikado : AniColors.olive,
                  icon: Icons.wb_sunny_outlined,
                ),
                if (jas != null)
                  AniPill(l.ensoJasValue('${jas >= 0 ? '+' : ''}${jas.toStringAsFixed(1)}'), color: AniColors.muted),
              ],
            ),
            if (enso.isElNino) ...[
              const SizedBox(height: AniSpacing.md),
              Text(l.elNinoExpected, style: theme.textTheme.titleMedium),
            ],
          ],
        ),
      ),
      const SizedBox(height: AniSpacing.md),
      AniCard(
        key: const ValueKey('home-dryness'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow('${l.drynessTitle} · ${latest.month}'),
            const SizedBox(height: AniSpacing.sm),
            AniPill(l.drynessLabelName(latest.label), color: dryColor),
          ],
        ),
      ),
      const SizedBox(height: AniSpacing.md),
      AniCard(
        key: const ValueKey('home-crops'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow(l.navCrops),
            const SizedBox(height: AniSpacing.xs),
            Text(l.homeCropCount(b.crops.length), style: theme.textTheme.titleSmall),
            const SizedBox(height: AniSpacing.sm),
            Wrap(
              spacing: AniSpacing.sm,
              runSpacing: AniSpacing.sm,
              children: [for (final c in b.crops.values) AniPill(l.cropName(c))],
            ),
          ],
        ),
      ),
    ];
  }
}
