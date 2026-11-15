import 'package:flutter/material.dart';

import 'features/farm/farm_screen.dart';
import 'features/home/home_screen.dart';
import 'features/library/library_screen.dart';
import 'features/outlook/outlook_screen.dart';
import 'l10n/app_localizations.dart';
import 'theme/theme.dart';

/// Main app scaffold: four tabs kept alive in an [IndexedStack].
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AniColors.cream,
      body: IndexedStack(
        index: _index,
        children: const [HomeScreen(), OutlookScreen(), LibraryScreen(), FarmScreen()],
      ),
      bottomNavigationBar: AniBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          AniNavItem(Icons.home_outlined, l.navHome),
          AniNavItem(Icons.wb_sunny_outlined, l.navOutlook),
          AniNavItem(Icons.eco_outlined, l.navCrops),
          AniNavItem(Icons.agriculture_outlined, l.navMyFarm),
        ],
      ),
    );
  }
}
