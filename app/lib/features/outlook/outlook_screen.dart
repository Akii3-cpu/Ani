import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../placeholder_screen.dart';

/// Placeholder until the real screen lands.
class OutlookScreen extends StatelessWidget {
  const OutlookScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      PlaceholderScreen(title: AppLocalizations.of(context).navOutlook, icon: Icons.wb_sunny_outlined);
}
