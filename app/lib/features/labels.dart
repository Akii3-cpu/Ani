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

  /// PAGASA category name for a bundle `heat.index_categories_c[].label`.
  String heatCategoryName(String label) => switch (label) {
        'extreme danger' => heatExtremeDanger,
        'danger' => heatDanger,
        'extreme caution' => heatExtremeCaution,
        _ => heatCaution,
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

/// Pale banner fill behind a dryness label's status colour.
Color drynessBgColor(String label) => switch (label) {
      DrynessLabel.delikado => AniColors.statusDelikadoBg,
      DrynessLabel.bantay => AniColors.statusBantayBg,
      _ => AniColors.statusNormalBg,
    };

/// Status colour for a dryness label.
Color drynessColor(String label) => switch (label) {
      DrynessLabel.delikado => AniColors.statusDelikado,
      DrynessLabel.bantay => AniColors.statusBantay,
      _ => AniColors.statusNormal,
    };
