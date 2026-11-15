import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../placeholder_screen.dart';

/// Placeholder until the real screen lands.
class FarmScreen extends StatelessWidget {
  const FarmScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      PlaceholderScreen(title: AppLocalizations.of(context).navMyFarm, icon: Icons.agriculture_outlined);
}
