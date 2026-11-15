// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'Ani';

  @override
  String get onboardingLanguageTitle => 'Piliin ang iyong wika';

  @override
  String get onboardingLanguageSubtitle =>
      'Maaari mo itong palitan mamaya sa settings.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFilipino => 'Filipino';

  @override
  String get onboardingTownTitle => 'Saan ang inyong bukid?';

  @override
  String get onboardingTownSubtitle =>
      'Gagamitin namin ang datos ng panahon at lupa ng inyong bayan.';

  @override
  String get townGuimba => 'Guimba';

  @override
  String get townMunoz => 'Science City of Muñoz';

  @override
  String get townBongabon => 'Bongabon';

  @override
  String get onboardingContinue => 'Magpatuloy';

  @override
  String get onboardingBack => 'Bumalik';

  @override
  String onboardingStepOf(int step, int total) {
    return 'Hakbang $step sa $total';
  }

  @override
  String get navHome => 'Simula';

  @override
  String get navOutlook => 'Tanaw';

  @override
  String get navCrops => 'Pananim';

  @override
  String get navMyFarm => 'Aking bukid';

  @override
  String get comingSoon => 'Malapit na ang screen na ito.';

  @override
  String get settingsTitle => 'Mga setting';

  @override
  String get settingsChangeTown => 'Palitan ang bayan';

  @override
  String get settingsChangeLanguage => 'Palitan ang wika';

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
  String get homeCta => 'Ano ang dapat kong itanim?';

  @override
  String get homeOutlookTitle => 'Tanaw sa tag-araw';

  @override
  String get homeTrackedTitle => 'Ang inyong tanim';

  @override
  String get homeTrackedEmpty => 'Wala pang binabantayang tanim.';

  @override
  String get alertsTitle => 'Mga babala';

  @override
  String get alertsEmpty => 'Walang babala sa ngayon.';

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
  String get drynessTitle => 'Pagkatuyo';

  @override
  String drynessRank(int rank, int n) {
    return 'Ika-$rank sa pinakatuyo sa $n na taon';
  }

  @override
  String get drynessChartTitle => 'Buwanang sukat ng pagkatuyo';

  @override
  String get drynessChartElNino => 'Mga panahon ng El Niño';

  @override
  String get heatSafetyTitle => 'Kaligtasan sa init';

  @override
  String heatIndexValue(String value) {
    return 'Heat index $value°C';
  }

  @override
  String get heatCaution => 'Mag-ingat';

  @override
  String get heatExtremeCaution => 'Labis na mag-ingat';

  @override
  String get heatDanger => 'Mapanganib';

  @override
  String get heatExtremeDanger => 'Lubhang mapanganib';

  @override
  String get heatSafetyNote =>
      'Para lang sa kaligtasan ng tao. Hindi ginagamit sa pagpili ng pananim.';

  @override
  String questionStepOf(int step, int total) {
    return 'Tanong $step sa $total';
  }

  @override
  String get questionTownTitle => 'Saang bayan ang inyong bukid?';

  @override
  String get questionLastCropsTitle =>
      'Ano ang huling dalawang itinanim ninyo?';

  @override
  String get questionLastCropsHint =>
      'Ang pinakahuli muna. Piliin ang Wala kung walang tanim.';

  @override
  String get questionWaterTitle => 'Gaano karaming patubig ang kaya ninyo?';

  @override
  String get waterRainfed => 'Ulan lang (walang patubig)';

  @override
  String get waterLimited2 => 'Mga 2 patubig';

  @override
  String get waterLimited4 => 'Mga 4 na patubig';

  @override
  String get waterFull => 'Patubig kung kailangan';

  @override
  String get questionWontTitle => 'May pananim bang ayaw ninyong itanim?';

  @override
  String get questionColdStorage => 'May magagamit akong cold storage';

  @override
  String get questionPrioritiesTitle => 'Ano ang pinakamahalaga sa inyo?';

  @override
  String get questionPrioritiesHint =>
      'Pindutin ang nangungunang 3, ang pinakamahalaga muna.';

  @override
  String get priorityIncome => 'Kita';

  @override
  String get priorityRisk => 'Mababang panganib';

  @override
  String get priorityWater => 'Tipid sa tubig';

  @override
  String get prioritySoil => 'Kalusugan ng lupa';

  @override
  String get priorityPest => 'Mas kaunting peste';

  @override
  String get answerNone => 'Wala';

  @override
  String get questionSeeResult => 'Tingnan ang payo';

  @override
  String get resultTitle => 'Mga mungkahing pananim';

  @override
  String cardFailedSeasons(int failed, int seasons) {
    return 'Nasira sa $failed sa $seasons na taon';
  }

  @override
  String cardFailRange(String low, String high) {
    return 'Maaaring $low–$high';
  }

  @override
  String cardWaterNeeded(int mm) {
    return 'Kailangang tubig: $mm mm';
  }

  @override
  String cardNetIncome(String low, String high) {
    return 'Netong kita: $low hanggang $high bawat ektarya';
  }

  @override
  String get confidenceLabel => 'Katiyakan';

  @override
  String get confidenceHigh => 'Mataas';

  @override
  String get confidenceMedium => 'Katamtaman';

  @override
  String get confidenceLow => 'Mababa';

  @override
  String get lowConfidenceNote =>
      'Mababa ang katiyakan. Makipag-usap muna sa inyong Municipal Agriculture Office.';

  @override
  String get onionPriceWarning =>
      'Walang cold storage: mataas ang panganib sa presyo';

  @override
  String get holdReasonLabel => 'Bakit hindi muna';

  @override
  String get holdTip =>
      'Takpan ng dayami (mulch) o iwanang pahinga ang lupa; ihanda ang patubig para sa susunod.';

  @override
  String get resultTrackThis => 'Bantayan ang tanim na ito';

  @override
  String get resultStartOver => 'Sumagot muli';

  @override
  String get myFarmAddPlanting => 'Magdagdag ng tanim';

  @override
  String get plantingCrop => 'Pananim';

  @override
  String get plantingDate => 'Petsa ng pagtatanim';

  @override
  String get plantingMethod => 'Paraan';

  @override
  String get methodDirectSeed => 'Direktang pagtatanim';

  @override
  String get methodTransplant => 'Paglilipat-tanim';

  @override
  String get plantingIrrigation => 'Patubig';

  @override
  String get plantingSave => 'I-save';

  @override
  String get stagePrep => 'Paghahanda';

  @override
  String get stageEstab => 'Pagtubo';

  @override
  String get stageVeg => 'Paglaki';

  @override
  String get stageRepro => 'Pamumulaklak';

  @override
  String get stageMature => 'Paghinog';

  @override
  String get stageHarvest => 'Anihan';

  @override
  String get stageFailed => 'Nasira';

  @override
  String trackerDay(int day) {
    return 'Ika-$day na araw';
  }

  @override
  String expectedHarvest(String start, String end) {
    return 'Inaasahang ani: $start – $end';
  }

  @override
  String get confirmHarvest => 'Kumpirmahin ang ani';

  @override
  String get waitingForData => 'Hinihintay ang datos';

  @override
  String waitingForDataDays(int count) {
    return '$count araw na hinihintay ang datos';
  }

  @override
  String lastUpdated(String date) {
    return 'Na-update $date';
  }

  @override
  String get offlineNote => 'Offline: gamit ang naka-save na datos';

  @override
  String get demoReplayLabel => 'Replay ng nakaraang panahon';

  @override
  String get alertWaterNow => 'Magpatubig na';

  @override
  String get alertWaterNowBody =>
      'Natutuyo na ang lupa. Magpatubig sa loob ng isa o dalawang araw.';

  @override
  String get alertHeatFlowering => 'Init sa pamumulaklak';

  @override
  String get alertHeatFloweringBody =>
      'Ang sobrang init habang namumulaklak ay maaaring magpababa ng ani. Panatilihing basa ang lupa.';

  @override
  String get alertOnionRot => 'Panganib ng pagkabulok ng sibuyas';

  @override
  String get alertOnionRotBody =>
      'Sobrang basa ang lupa. Itigil muna ang patubig at padaluyin ang tubig.';

  @override
  String get alertFailed => 'Nasira ang tanim';

  @override
  String get alertFailedBody => 'Malabong makabawi ang tanim ngayong panahon.';

  @override
  String get alertHarvestReady => 'Handa nang anihin';

  @override
  String get alertHarvestReadyBody =>
      'Hinog na ang inyong tanim. Kumpirmahin kapag umani na kayo.';

  @override
  String get libraryTitle => 'Mga pananim';

  @override
  String cropDurationDays(int days) {
    return '$days araw';
  }

  @override
  String get cropDurationLabel => 'Haba ng panahon';

  @override
  String get cropSowingWindow => 'Panahon ng pagtatanim';

  @override
  String get cropFamily => 'Pamilya';

  @override
  String get cropWaterNeed => 'Kailangang tubig';

  @override
  String get cropRiskByIrrigation => 'Nasirang panahon ayon sa patubig';

  @override
  String get aboutTitle => 'Tungkol at mga limitasyon';

  @override
  String get aboutAdvisory =>
      'Payo lang ang Ani. Ang panahon ay mula sa iisang punto bawat bayan, at pinakamababang tantya ang tubig para sa palay. Hindi pa ito nasubok sa bukid.';

  @override
  String get aboutSources =>
      'Datos: NASA POWER, ISRIC SoilGrids, NOAA CPC, PSA.';

  @override
  String get actionRetry => 'Subukan muli';

  @override
  String get actionClose => 'Isara';

  @override
  String get actionCancel => 'Kanselahin';

  @override
  String get bundleLoadError => 'Hindi ma-load ang datos para sa bayang ito.';

  @override
  String homeCropCount(int count) {
    return '$count pananim sa datos ng bayang ito';
  }

  @override
  String get recommendTitle => 'Ano ang dapat kong itanim?';

  @override
  String get questionLastCropRecent => 'Pinakahuling tanim';

  @override
  String get questionLastCropBefore => 'Ang tanim bago noon';

  @override
  String get questionWaterSourceLabel => 'Saan galing ang inyong tubig?';

  @override
  String get questionIrrigationsLabel =>
      'Ilang beses kayong makapagpapatubig ngayong tag-araw?';

  @override
  String get sourceRain => 'Ulan lang';

  @override
  String get sourcePump => 'Bomba o mababaw na balon';

  @override
  String get sourceCanal => 'Kanal ng patubig (NIA o komunal)';

  @override
  String get sourceRiver => 'Ilog, sapa o lawa';

  @override
  String get questionWontHint =>
      'Pindutin ang ayaw ninyong itanim. Iwanang walang pili kung wala.';

  @override
  String get questionColdStorageLabel => 'Cold storage';

  @override
  String get questionColdStorageHint => 'Mahalaga sa presyo ng sibuyas.';

  @override
  String questionPrioritiesPicked(int count) {
    return '$count sa 3 ang napili';
  }

  @override
  String cardFailedSeasonsElNino(int failed, int seasons) {
    return 'Nasira sa $failed sa $seasons na El Niño na taon';
  }

  @override
  String cardRank(int rank) {
    return 'Ika-$rank';
  }

  @override
  String cardConfidence(String level) {
    return 'Katiyakan: $level';
  }

  @override
  String get cardSmallMarket =>
      'Maliit ang lokal na pamilihan: kumonsulta sa MAO';

  @override
  String resultSubtitle(String town, String water) {
    return '$town · $water';
  }

  @override
  String get resultElNinoMode =>
      'Taon ng El Niño: mas mabigat ang tubig at panganib';

  @override
  String get resultDone => 'Tapos na';

  @override
  String get resultSaved => 'Naka-save sa teleponong ito ang inyong mga sagot.';

  @override
  String holdRemovedCrops(String crops) {
    return 'Tinanggal: $crops';
  }

  @override
  String get holdTipLabel => 'Ano ang magagawa';

  @override
  String get holdGuardWater =>
      'Masyadong mataas ang tsansang masira sa inyong patubig ngayong El Niño.';

  @override
  String get holdGuardFarmer =>
      'Wala nang natirang pananim matapos alisin ang ayaw ninyong itanim.';

  @override
  String get holdGuardHeat => 'Masyadong mainit sa panahon ng pamumulaklak.';

  @override
  String get holdGuardProfit =>
      'Walang pananim na inaasahang kikita ngayong tag-araw sa inyong patubig.';

  @override
  String get holdGuardSeason => 'Walang pananim na angkop sa tag-araw.';

  @override
  String get recommendNoSaved => 'Wala pang naka-save na sagot.';

  @override
  String get homeLastRecommendation => 'Tingnan ang huling payo';

  @override
  String get homeLastRecommendationTitle => 'Huling payo';

  @override
  String drynessRankWet(int rank, int n) {
    return 'Ika-$rank sa pinakabasa sa $n na taon';
  }

  @override
  String drynessDValue(String value) {
    return 'D $value';
  }

  @override
  String homeHeatDangerFrom(String category, String value) {
    return 'Sa mga araw na $category (heat index $value°C pataas):';
  }

  @override
  String get homeTrackedHint =>
      'Magtala ng tanim para makita rito ang yugto at mga babala nito.';
}
