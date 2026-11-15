import 'package:flutter/widgets.dart';

import '../data/bundle.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme.dart';

/// Localized labels for bundle values shared across screens.
extension AniLabels on AppLocalizations {
  String townName(Town town) => switch (town) {
        Town.guimba => townGuimba,
        Town.munoz => townMunoz,
        Town.bongabon => townBongabon,
      };

  String ensoTagName(String tag) => switch (tag) {
        EnsoTag.elNino => ensoElNino,
        EnsoTag.laNina => ensoLaNina,
        _ => ensoNeutral,
      };

  String drynessLabelName(String label) => switch (label) {
        DrynessLabel.delikado => dryDelikado,
        DrynessLabel.bantay => dryBantay,
        _ => dryNormal,
      };

  /// Crop name from planner.NAME; falls back to the bundle's own name.
  String cropName(CropInfo crop) => switch (crop.id) {
        CropId.rice => cropPalay,
        CropId.onion => cropSibuyas,
        CropId.mungbean => cropMunggo,
        CropId.maize => cropMais,
        CropId.sweetPotato => cropKamote,
        _ => crop.name,
      };
}

/// Status colour for a dryness label.
Color drynessColor(String label) => switch (label) {
      DrynessLabel.delikado => AniColors.statusDelikado,
      DrynessLabel.bantay => AniColors.statusBantay,
      _ => AniColors.statusNormal,
    };
