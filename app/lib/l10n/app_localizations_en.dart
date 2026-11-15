// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ani';

  @override
  String get onboardingLanguageTitle => 'Choose your language';

  @override
  String get onboardingLanguageSubtitle =>
      'You can change this later in settings.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFilipino => 'Filipino';

  @override
  String get onboardingTownTitle => 'Where is your farm?';

  @override
  String get onboardingTownSubtitle =>
      'We use the weather and soil data for your town.';

  @override
  String get townGuimba => 'Guimba';

  @override
  String get townMunoz => 'Science City of Muñoz';

  @override
  String get townBongabon => 'Bongabon';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingBack => 'Back';

  @override
  String onboardingStepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navOutlook => 'Outlook';

  @override
  String get navCrops => 'Crops';

  @override
  String get navMyFarm => 'My farm';

  @override
  String get comingSoon => 'This screen is coming soon.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsChangeTown => 'Change town';

  @override
  String get settingsChangeLanguage => 'Change language';

  @override
  String get cropPalay => 'Palay';

  @override
  String get cropSibuyas => 'Sibuyas';

  @override
  String get cropMunggo => 'Munggo';

  @override
  String get cropMais => 'Mais';

  @override
  String get cropKamote => 'Kamote';

  @override
  String get cropPalayGloss => 'Rice';

  @override
  String get cropSibuyasGloss => 'Onion';

  @override
  String get cropMunggoGloss => 'Mung bean';

  @override
  String get cropMaisGloss => 'Maize';

  @override
  String get cropKamoteGloss => 'Sweet potato';

  @override
  String get holdTitle => 'Huwag munang magtanim';

  @override
  String get whyLabel => 'Bakit?';

  @override
  String get dryNormal => 'Normal';

  @override
  String get dryBantay => 'Bantay';

  @override
  String get dryDelikado => 'Delikado';

  @override
  String get consultMao => 'Kumonsulta sa MAO';

  @override
  String get workEarly => 'Magtrabaho nang maaga';

  @override
  String get elNinoExpected => 'Inaasahan ang El Niño ngayong tag-araw';

  @override
  String get homeCta => 'What should I plant?';

  @override
  String get homeOutlookTitle => 'Dry-season outlook';

  @override
  String get homeTrackedTitle => 'Your crop';

  @override
  String get homeTrackedEmpty => 'No crop tracked yet.';

  @override
  String get alertsTitle => 'Alerts';

  @override
  String get alertsEmpty => 'No alerts right now.';

  @override
  String get ensoElNino => 'El Niño';

  @override
  String get ensoLaNina => 'La Niña';

  @override
  String get ensoNeutral => 'Neutral';

  @override
  String ensoJasValue(String value) {
    return 'JAS $value';
  }

  @override
  String get drynessTitle => 'Dryness';

  @override
  String drynessRank(int rank, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      rank,
      locale: localeName,
      other: 'No. $rank driest',
      one: 'Driest',
    );
    String _temp1 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n years',
      one: '1 year',
    );
    return '$_temp0 of $_temp1';
  }

  @override
  String get drynessChartTitle => 'Monthly dryness index';

  @override
  String get drynessChartElNino => 'El Niño seasons';

  @override
  String get heatSafetyTitle => 'Heat safety';

  @override
  String heatIndexValue(String value) {
    return 'Heat index $value°C';
  }

  @override
  String get heatCaution => 'Caution';

  @override
  String get heatExtremeCaution => 'Extreme caution';

  @override
  String get heatDanger => 'Danger';

  @override
  String get heatExtremeDanger => 'Extreme danger';

  @override
  String get heatSafetyNote =>
      'For people\'s safety only. Not used to choose crops.';

  @override
  String questionStepOf(int step, int total) {
    return 'Question $step of $total';
  }

  @override
  String get questionTownTitle => 'Which town is your farm in?';

  @override
  String get questionLastCropsTitle => 'What were your last two crops?';

  @override
  String get questionLastCropsHint => 'Pick up to two.';

  @override
  String get questionWaterTitle => 'How much water can you give?';

  @override
  String get waterRainfed => 'Rain only (no irrigation)';

  @override
  String get waterLimited2 => 'About 2 irrigations';

  @override
  String get waterLimited4 => 'About 4 irrigations';

  @override
  String get waterFull => 'Irrigate as needed';

  @override
  String get questionWontTitle => 'Any crops you won\'t plant?';

  @override
  String get questionColdStorage => 'I can use cold storage';

  @override
  String get questionPrioritiesTitle => 'What matters most to you?';

  @override
  String get questionPrioritiesHint => 'Tap your top 3, most important first.';

  @override
  String get priorityIncome => 'Income';

  @override
  String get priorityRisk => 'Low risk';

  @override
  String get priorityWater => 'Saves water';

  @override
  String get prioritySoil => 'Soil health';

  @override
  String get priorityPest => 'Fewer pests';

  @override
  String get answerNone => 'None';

  @override
  String get questionSeeResult => 'See advice';

  @override
  String get resultTitle => 'Suggested crops';

  @override
  String cardFailedSeasons(int failed, int seasons) {
    String _temp0 = intl.Intl.pluralLogic(
      seasons,
      locale: localeName,
      other: '$seasons years',
      one: '1 year',
    );
    return 'Failed in $failed of $_temp0';
  }

  @override
  String cardFailRange(String low, String high) {
    return 'Likely range $low–$high';
  }

  @override
  String cardWaterNeeded(int mm) {
    return 'Water needed: $mm mm';
  }

  @override
  String cardNetIncome(String low, String high) {
    return 'Net income: ₱$low to ₱$high per hectare';
  }

  @override
  String get confidenceLabel => 'Confidence';

  @override
  String get confidenceHigh => 'High';

  @override
  String get confidenceMedium => 'Medium';

  @override
  String get confidenceLow => 'Low';

  @override
  String get lowConfidenceNote =>
      'Low confidence. Please check with your Municipal Agriculture Office.';

  @override
  String get onionPriceWarning => 'No cold storage: high price risk';

  @override
  String get holdReasonLabel => 'Why not now';

  @override
  String get holdTip =>
      'Cover the soil with straw (mulch) or let it rest, and get irrigation ready for next season.';

  @override
  String get resultTrackThis => 'Track this crop';

  @override
  String get resultStartOver => 'Answer again';

  @override
  String get myFarmAddPlanting => 'Add planting';

  @override
  String get plantingCrop => 'Crop';

  @override
  String get plantingDate => 'Planting date';

  @override
  String get plantingMethod => 'Method';

  @override
  String get methodDirectSeed => 'Direct seeding';

  @override
  String get methodTransplant => 'Transplanting';

  @override
  String get plantingIrrigation => 'Irrigation';

  @override
  String get plantingSave => 'Save';

  @override
  String get stagePrep => 'Prep';

  @override
  String get stageEstab => 'Establishment';

  @override
  String get stageVeg => 'Vegetative';

  @override
  String get stageRepro => 'Flowering';

  @override
  String get stageMature => 'Maturing';

  @override
  String get stageHarvest => 'Harvest';

  @override
  String get stageFailed => 'Failed';

  @override
  String trackerDay(int day) {
    return 'Day $day';
  }

  @override
  String expectedHarvest(String start, String end) {
    return 'Expected harvest: $start – $end';
  }

  @override
  String get confirmHarvest => 'Confirm harvest';

  @override
  String get waitingForData => 'Waiting for data';

  @override
  String waitingForDataDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days waiting for data',
      one: '1 day waiting for data',
    );
    return '$_temp0';
  }

  @override
  String lastUpdated(String date) {
    return 'Updated $date';
  }

  @override
  String get offlineNote => 'Offline: using saved data';

  @override
  String get demoReplayLabel => 'Replay of a past season';

  @override
  String get alertWaterNow => 'Water now';

  @override
  String get alertWaterNowBody =>
      'The soil is drying out. Irrigate in the next day or two.';

  @override
  String get alertHeatFlowering => 'Heat at flowering';

  @override
  String get alertHeatFloweringBody =>
      'Very hot days during flowering can lower your harvest. Keep the soil moist.';

  @override
  String get alertOnionRot => 'Onion rot risk';

  @override
  String get alertOnionRotBody =>
      'The soil is too wet. Hold off on watering and let the field drain.';

  @override
  String get alertFailed => 'Crop failed';

  @override
  String get alertFailedBody => 'The crop is unlikely to recover this season.';

  @override
  String get alertHarvestReady => 'Ready to harvest';

  @override
  String get alertHarvestReadyBody =>
      'Your crop has reached maturity. Confirm when you harvest.';

  @override
  String get libraryTitle => 'Crop library';

  @override
  String cropDurationDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get cropDurationLabel => 'Duration';

  @override
  String get cropSowingWindow => 'Sowing window';

  @override
  String get cropFamily => 'Family';

  @override
  String get cropWaterNeed => 'Water need';

  @override
  String get cropRiskByIrrigation => 'Failed seasons by irrigation';

  @override
  String get aboutTitle => 'About and limits';

  @override
  String get aboutAdvisory =>
      'Ani gives advice only. Weather is from one point per town, and rice water need is a lower bound. Results were not tested in the field.';

  @override
  String get aboutSources =>
      'Data: NASA POWER, ISRIC SoilGrids, NOAA CPC, PSA.';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionClose => 'Close';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get bundleLoadError => 'Could not load the data for this town.';

  @override
  String homeCropCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count crops in this town\'s data',
      one: '1 crop in this town\'s data',
    );
    return '$_temp0';
  }
}
