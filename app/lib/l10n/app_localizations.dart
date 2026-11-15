import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fil.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fil'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Ani'**
  String get appTitle;

  /// Onboarding step 1 title
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onboardingLanguageTitle;

  /// Onboarding step 1 subtitle
  ///
  /// In en, this message translates to:
  /// **'You can change this later in settings.'**
  String get onboardingLanguageSubtitle;

  /// Language option; shown in its own language in both locales
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Language option; shown in its own language in both locales
  ///
  /// In en, this message translates to:
  /// **'Filipino'**
  String get languageFilipino;

  /// Onboarding step 2 title (town picker)
  ///
  /// In en, this message translates to:
  /// **'Where is your farm?'**
  String get onboardingTownTitle;

  /// Onboarding step 2 subtitle
  ///
  /// In en, this message translates to:
  /// **'We use the weather and soil data for your town.'**
  String get onboardingTownSubtitle;

  /// Town name (proper noun, same in both locales)
  ///
  /// In en, this message translates to:
  /// **'Guimba'**
  String get townGuimba;

  /// Town name (proper noun, same in both locales)
  ///
  /// In en, this message translates to:
  /// **'Science City of Muñoz'**
  String get townMunoz;

  /// Town name (proper noun, same in both locales)
  ///
  /// In en, this message translates to:
  /// **'Bongabon'**
  String get townBongabon;

  /// Primary button to go to the next onboarding step
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// Button to go to the previous onboarding step
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// Onboarding progress label
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onboardingStepOf(int step, int total);

  /// Bottom nav tab: Start/Home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav tab: season outlook
  ///
  /// In en, this message translates to:
  /// **'Outlook'**
  String get navOutlook;

  /// Bottom nav tab: crop library
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get navCrops;

  /// Bottom nav tab: tracked plantings
  ///
  /// In en, this message translates to:
  /// **'My farm'**
  String get navMyFarm;

  /// Placeholder text for screens not built yet
  ///
  /// In en, this message translates to:
  /// **'This screen is coming soon.'**
  String get comingSoon;

  /// Settings sheet title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings action: re-pick the town
  ///
  /// In en, this message translates to:
  /// **'Change town'**
  String get settingsChangeTown;

  /// Settings action: re-pick the language
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get settingsChangeLanguage;

  /// Crop name (rice); Filipino name used in both locales, from planner.NAME
  ///
  /// In en, this message translates to:
  /// **'Palay'**
  String get cropPalay;

  /// Crop name (onion); Filipino name used in both locales, from planner.NAME
  ///
  /// In en, this message translates to:
  /// **'Sibuyas'**
  String get cropSibuyas;

  /// Crop name (mung bean); Filipino name used in both locales, from planner.NAME
  ///
  /// In en, this message translates to:
  /// **'Munggo'**
  String get cropMunggo;

  /// Crop name (maize); Filipino name used in both locales, from planner.NAME
  ///
  /// In en, this message translates to:
  /// **'Mais'**
  String get cropMais;

  /// Crop name (sweet potato); Filipino name used in both locales, from planner.NAME
  ///
  /// In en, this message translates to:
  /// **'Kamote'**
  String get cropKamote;

  /// English gloss for Palay; UI may show it next to the name in English only
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get cropPalayGloss;

  /// English gloss for Sibuyas; UI may show it next to the name in English only
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get cropSibuyasGloss;

  /// English gloss for Munggo; UI may show it next to the name in English only
  ///
  /// In en, this message translates to:
  /// **'Mung bean'**
  String get cropMunggoGloss;

  /// English gloss for Mais; UI may show it next to the name in English only
  ///
  /// In en, this message translates to:
  /// **'Maize'**
  String get cropMaisGloss;

  /// English gloss for Kamote; UI may show it next to the name in English only
  ///
  /// In en, this message translates to:
  /// **'Sweet potato'**
  String get cropKamoteGloss;

  /// Hold screen title; doc-quoted, Filipino in both locales
  ///
  /// In en, this message translates to:
  /// **'Huwag munang magtanim'**
  String get holdTitle;

  /// Label for the reasons on a crop card; doc-quoted, Filipino in both locales
  ///
  /// In en, this message translates to:
  /// **'Bakit?'**
  String get whyLabel;

  /// Dryness alert level; doc-quoted, same in both locales
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get dryNormal;

  /// Dryness alert level (watch); doc-quoted, Filipino in both locales
  ///
  /// In en, this message translates to:
  /// **'Bantay'**
  String get dryBantay;

  /// Dryness alert level (danger); doc-quoted, Filipino in both locales
  ///
  /// In en, this message translates to:
  /// **'Delikado'**
  String get dryDelikado;

  /// Referral to the Municipal Agriculture Office; doc-quoted, Filipino in both locales
  ///
  /// In en, this message translates to:
  /// **'Kumonsulta sa MAO'**
  String get consultMao;

  /// Heat safety advice on danger days; doc-quoted, Filipino in both locales
  ///
  /// In en, this message translates to:
  /// **'Magtrabaho nang maaga'**
  String get workEarly;

  /// El Niño outlook headline; doc-quoted, Filipino in both locales
  ///
  /// In en, this message translates to:
  /// **'Inaasahan ang El Niño ngayong tag-araw'**
  String get elNinoExpected;

  /// Home call-to-action that opens the recommendation questionnaire
  ///
  /// In en, this message translates to:
  /// **'What should I plant?'**
  String get homeCta;

  /// Home card title for the El Niño season outlook
  ///
  /// In en, this message translates to:
  /// **'Dry-season outlook'**
  String get homeOutlookTitle;

  /// Home card title for the tracked-crop summary
  ///
  /// In en, this message translates to:
  /// **'Your crop'**
  String get homeTrackedTitle;

  /// Empty state for the tracked-crop summary
  ///
  /// In en, this message translates to:
  /// **'No crop tracked yet.'**
  String get homeTrackedEmpty;

  /// Alerts list title
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsTitle;

  /// Empty state for the alerts list
  ///
  /// In en, this message translates to:
  /// **'No alerts right now.'**
  String get alertsEmpty;

  /// ENSO phase tag
  ///
  /// In en, this message translates to:
  /// **'El Niño'**
  String get ensoElNino;

  /// ENSO phase tag
  ///
  /// In en, this message translates to:
  /// **'La Niña'**
  String get ensoLaNina;

  /// ENSO phase tag
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get ensoNeutral;

  /// ENSO index for July-August-September, e.g. 'JAS +2.2'; value is preformatted
  ///
  /// In en, this message translates to:
  /// **'JAS {value}'**
  String ensoJasValue(String value);

  /// Title of the dryness banner/chart
  ///
  /// In en, this message translates to:
  /// **'Dryness'**
  String get drynessTitle;

  /// Rank sentence under the dryness banner: this season is the rank-th driest of n years on record
  ///
  /// In en, this message translates to:
  /// **'{rank, plural, =1{Driest} other{No. {rank} driest}} of {n, plural, =1{1 year} other{{n} years}}'**
  String drynessRank(int rank, int n);

  /// Outlook chart title
  ///
  /// In en, this message translates to:
  /// **'Monthly dryness index'**
  String get drynessChartTitle;

  /// Chart legend for El Niño seasons
  ///
  /// In en, this message translates to:
  /// **'El Niño seasons'**
  String get drynessChartElNino;

  /// Heat safety strip/section title
  ///
  /// In en, this message translates to:
  /// **'Heat safety'**
  String get heatSafetyTitle;

  /// Heat index reading; value is preformatted
  ///
  /// In en, this message translates to:
  /// **'Heat index {value}°C'**
  String heatIndexValue(String value);

  /// PAGASA heat index category
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get heatCaution;

  /// PAGASA heat index category
  ///
  /// In en, this message translates to:
  /// **'Extreme caution'**
  String get heatExtremeCaution;

  /// PAGASA heat index category
  ///
  /// In en, this message translates to:
  /// **'Danger'**
  String get heatDanger;

  /// PAGASA heat index category
  ///
  /// In en, this message translates to:
  /// **'Extreme danger'**
  String get heatExtremeDanger;

  /// Disclaimer under heat safety (doc requirement)
  ///
  /// In en, this message translates to:
  /// **'For people\'s safety only. Not used to choose crops.'**
  String get heatSafetyNote;

  /// Questionnaire progress label
  ///
  /// In en, this message translates to:
  /// **'Question {step} of {total}'**
  String questionStepOf(int step, int total);

  /// Questionnaire step 1
  ///
  /// In en, this message translates to:
  /// **'Which town is your farm in?'**
  String get questionTownTitle;

  /// Questionnaire step 2
  ///
  /// In en, this message translates to:
  /// **'What were your last two crops?'**
  String get questionLastCropsTitle;

  /// Hint for step 2
  ///
  /// In en, this message translates to:
  /// **'Pick up to two.'**
  String get questionLastCropsHint;

  /// Questionnaire step 3
  ///
  /// In en, this message translates to:
  /// **'How much water can you give?'**
  String get questionWaterTitle;

  /// Water option: rainfed
  ///
  /// In en, this message translates to:
  /// **'Rain only (no irrigation)'**
  String get waterRainfed;

  /// Water option: limited_2
  ///
  /// In en, this message translates to:
  /// **'About 2 irrigations'**
  String get waterLimited2;

  /// Water option: limited_4
  ///
  /// In en, this message translates to:
  /// **'About 4 irrigations'**
  String get waterLimited4;

  /// Water option: full
  ///
  /// In en, this message translates to:
  /// **'Irrigate as needed'**
  String get waterFull;

  /// Questionnaire step 4
  ///
  /// In en, this message translates to:
  /// **'Any crops you won\'t plant?'**
  String get questionWontTitle;

  /// Checkbox in step 4 (affects onion price-risk guard)
  ///
  /// In en, this message translates to:
  /// **'I can use cold storage'**
  String get questionColdStorage;

  /// Questionnaire step 5
  ///
  /// In en, this message translates to:
  /// **'What matters most to you?'**
  String get questionPrioritiesTitle;

  /// Hint for step 5
  ///
  /// In en, this message translates to:
  /// **'Tap your top 3, most important first.'**
  String get questionPrioritiesHint;

  /// Priority option
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get priorityIncome;

  /// Priority option
  ///
  /// In en, this message translates to:
  /// **'Low risk'**
  String get priorityRisk;

  /// Priority option
  ///
  /// In en, this message translates to:
  /// **'Saves water'**
  String get priorityWater;

  /// Priority option
  ///
  /// In en, this message translates to:
  /// **'Soil health'**
  String get prioritySoil;

  /// Priority option
  ///
  /// In en, this message translates to:
  /// **'Fewer pests'**
  String get priorityPest;

  /// Choice meaning no crop / nothing
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get answerNone;

  /// Final questionnaire button
  ///
  /// In en, this message translates to:
  /// **'See advice'**
  String get questionSeeResult;

  /// Result screen title
  ///
  /// In en, this message translates to:
  /// **'Suggested crops'**
  String get resultTitle;

  /// Crop risk line: number of failed seasons out of simulated seasons
  ///
  /// In en, this message translates to:
  /// **'Failed in {failed} of {seasons, plural, =1{1 year} other{{seasons} years}}'**
  String cardFailedSeasons(int failed, int seasons);

  /// Wilson interval for the failure rate; values are preformatted percents
  ///
  /// In en, this message translates to:
  /// **'Likely range {low}–{high}'**
  String cardFailRange(String low, String high);

  /// Season water need
  ///
  /// In en, this message translates to:
  /// **'Water needed: {mm} mm'**
  String cardWaterNeeded(int mm);

  /// Net income p10-p90; values are preformatted
  ///
  /// In en, this message translates to:
  /// **'Net income: ₱{low} to ₱{high} per hectare'**
  String cardNetIncome(String low, String high);

  /// Label before confidence level
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidenceLabel;

  /// Confidence level
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get confidenceHigh;

  /// Confidence level
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get confidenceMedium;

  /// Confidence level
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get confidenceLow;

  /// Shown with the MAO referral on Low confidence cards
  ///
  /// In en, this message translates to:
  /// **'Low confidence. Please check with your Municipal Agriculture Office.'**
  String get lowConfidenceNote;

  /// Onion price-risk warning (guard g3)
  ///
  /// In en, this message translates to:
  /// **'No cold storage: high price risk'**
  String get onionPriceWarning;

  /// Hold screen label before the blocking guard's reason
  ///
  /// In en, this message translates to:
  /// **'Why not now'**
  String get holdReasonLabel;

  /// Hold screen tip (fil text from planner.hold_message)
  ///
  /// In en, this message translates to:
  /// **'Cover the soil with straw (mulch) or let it rest, and get irrigation ready for next season.'**
  String get holdTip;

  /// Button on a crop card to start tracking
  ///
  /// In en, this message translates to:
  /// **'Track this crop'**
  String get resultTrackThis;

  /// Button to restart the questionnaire
  ///
  /// In en, this message translates to:
  /// **'Answer again'**
  String get resultStartOver;

  /// My farm: add a planting
  ///
  /// In en, this message translates to:
  /// **'Add planting'**
  String get myFarmAddPlanting;

  /// Planting form field
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get plantingCrop;

  /// Planting form field
  ///
  /// In en, this message translates to:
  /// **'Planting date'**
  String get plantingDate;

  /// Planting form field
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get plantingMethod;

  /// Planting method option
  ///
  /// In en, this message translates to:
  /// **'Direct seeding'**
  String get methodDirectSeed;

  /// Planting method option
  ///
  /// In en, this message translates to:
  /// **'Transplanting'**
  String get methodTransplant;

  /// Planting form field (defaults from profile)
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get plantingIrrigation;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get plantingSave;

  /// Field machine stage: land preparation
  ///
  /// In en, this message translates to:
  /// **'Prep'**
  String get stagePrep;

  /// Field machine stage: establishment
  ///
  /// In en, this message translates to:
  /// **'Establishment'**
  String get stageEstab;

  /// Field machine stage: vegetative
  ///
  /// In en, this message translates to:
  /// **'Vegetative'**
  String get stageVeg;

  /// Field machine stage: reproductive
  ///
  /// In en, this message translates to:
  /// **'Flowering'**
  String get stageRepro;

  /// Field machine stage: mature
  ///
  /// In en, this message translates to:
  /// **'Maturing'**
  String get stageMature;

  /// Field machine stage: harvest
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get stageHarvest;

  /// Field machine stage: failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get stageFailed;

  /// Days since planting
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String trackerDay(int day);

  /// Expected harvest window; dates preformatted
  ///
  /// In en, this message translates to:
  /// **'Expected harvest: {start} – {end}'**
  String expectedHarvest(String start, String end);

  /// Button that confirms harvest (transition 7)
  ///
  /// In en, this message translates to:
  /// **'Confirm harvest'**
  String get confirmHarvest;

  /// Day with no POWER data yet
  ///
  /// In en, this message translates to:
  /// **'Waiting for data'**
  String get waitingForData;

  /// Number of recent days without POWER data
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day waiting for data} other{{count} days waiting for data}}'**
  String waitingForDataDays(int count);

  /// Last sync time; date preformatted
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String lastUpdated(String date);

  /// Banner when no network
  ///
  /// In en, this message translates to:
  /// **'Offline: using saved data'**
  String get offlineNote;

  /// Label for demo mode
  ///
  /// In en, this message translates to:
  /// **'Replay of a past season'**
  String get demoReplayLabel;

  /// Alert title
  ///
  /// In en, this message translates to:
  /// **'Water now'**
  String get alertWaterNow;

  /// Alert body
  ///
  /// In en, this message translates to:
  /// **'The soil is drying out. Irrigate in the next day or two.'**
  String get alertWaterNowBody;

  /// Alert title
  ///
  /// In en, this message translates to:
  /// **'Heat at flowering'**
  String get alertHeatFlowering;

  /// Alert body
  ///
  /// In en, this message translates to:
  /// **'Very hot days during flowering can lower your harvest. Keep the soil moist.'**
  String get alertHeatFloweringBody;

  /// Alert title
  ///
  /// In en, this message translates to:
  /// **'Onion rot risk'**
  String get alertOnionRot;

  /// Alert body
  ///
  /// In en, this message translates to:
  /// **'The soil is too wet. Hold off on watering and let the field drain.'**
  String get alertOnionRotBody;

  /// Alert title
  ///
  /// In en, this message translates to:
  /// **'Crop failed'**
  String get alertFailed;

  /// Alert body
  ///
  /// In en, this message translates to:
  /// **'The crop is unlikely to recover this season.'**
  String get alertFailedBody;

  /// Alert title
  ///
  /// In en, this message translates to:
  /// **'Ready to harvest'**
  String get alertHarvestReady;

  /// Alert body
  ///
  /// In en, this message translates to:
  /// **'Your crop has reached maturity. Confirm when you harvest.'**
  String get alertHarvestReadyBody;

  /// Crop library title
  ///
  /// In en, this message translates to:
  /// **'Crop library'**
  String get libraryTitle;

  /// Crop duration
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String cropDurationDays(int days);

  /// Library field
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get cropDurationLabel;

  /// Library field
  ///
  /// In en, this message translates to:
  /// **'Sowing window'**
  String get cropSowingWindow;

  /// Library field (plant family)
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get cropFamily;

  /// Library field
  ///
  /// In en, this message translates to:
  /// **'Water need'**
  String get cropWaterNeed;

  /// Library table title
  ///
  /// In en, this message translates to:
  /// **'Failed seasons by irrigation'**
  String get cropRiskByIrrigation;

  /// About page title
  ///
  /// In en, this message translates to:
  /// **'About and limits'**
  String get aboutTitle;

  /// About page limits paragraph
  ///
  /// In en, this message translates to:
  /// **'Ani gives advice only. Weather is from one point per town, and rice water need is a lower bound. Results were not tested in the field.'**
  String get aboutAdvisory;

  /// Data sources
  ///
  /// In en, this message translates to:
  /// **'Data: NASA POWER, ISRIC SoilGrids, NOAA CPC, PSA.'**
  String get aboutSources;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Error card when the bundled town JSON fails to load
  ///
  /// In en, this message translates to:
  /// **'Could not load the data for this town.'**
  String get bundleLoadError;

  /// Home: number of crops in the loaded bundle
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 crop in this town\'s data} other{{count} crops in this town\'s data}}'**
  String homeCropCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fil'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fil':
      return AppLocalizationsFil();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
