import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../placeholder_screen.dart';

/// Placeholder until the real screen lands.
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      PlaceholderScreen(title: AppLocalizations.of(context).libraryTitle, icon: Icons.eco_outlined);
}
