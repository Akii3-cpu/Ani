import 'package:flutter/widgets.dart';

import 'data/bundle.dart';
import 'data/settings_store.dart';

/// App-wide state: language, town, onboarding flag and the town's bundle.
class AppState extends ChangeNotifier {
  AppState({Future<SettingsStore> Function()? openStore, BundleLoader? loader, this.assets})
      : _openStore = openStore ?? SettingsStore.load,
        _loader = loader ?? BundleLoader.instance;

  final Future<SettingsStore> Function() _openStore;
  final BundleLoader _loader;

  /// Asset bundle to read town JSON from (default rootBundle).
  final AssetBundle? assets;

  SettingsStore? _store;
  Future<void>? _initFuture;
  int _loadToken = 0;

  bool _initialized = false;
  String? _localeCode;
  Town? _town;
  bool _onboardingComplete = false;
  AniBundle? _bundle;
  Object? _bundleError;
  bool _bundleLoading = false;

  /// True once saved settings have been read.
  bool get initialized => _initialized;

  /// Selected language code, or null to follow the device.
  String? get localeCode => _localeCode;
  Locale? get locale => _localeCode == null ? null : Locale(_localeCode!);

  Town? get town => _town;
  bool get onboardingComplete => _onboardingComplete;

  /// The loaded bundle for [town], if any.
  AniBundle? get bundle => _bundle;
  Object? get bundleError => _bundleError;
  bool get bundleLoading => _bundleLoading;

  /// Reads saved settings and, if a town is saved, loads its bundle.
  /// Safe to call more than once.
  Future<void> init() => _initFuture ??= _init();

  Future<void> _init() async {
    final store = _store = await _openStore();
    _localeCode = store.locale;
    _town = store.town;
    _onboardingComplete = store.onboardingComplete;
    _initialized = true;
    notifyListeners();
    if (_town != null) await _loadBundle(_town!);
  }

  /// Switches the app language and saves it.
  Future<void> setLocale(String code) async {
    if (code == _localeCode) return;
    await _store?.setLocale(code);
    _localeCode = code;
    notifyListeners();
  }

  /// Saves [town], marks onboarding done and loads the bundle.
  Future<void> completeOnboarding(Town town) async {
    await _store?.setTown(town);
    await _store?.setOnboardingComplete(true);
    _onboardingComplete = true;
    await _switchTown(town);
  }

  /// Changes the town (from settings) and reloads the bundle.
  Future<void> setTown(Town town) async {
    if (town == _town && _bundle != null) return;
    await _store?.setTown(town);
    await _switchTown(town);
  }

  /// Retries loading the current town's bundle after an error.
  Future<void> retryBundle() async {
    if (_town != null) await _loadBundle(_town!);
  }

  // The previous bundle stays visible until the new one arrives.
  Future<void> _switchTown(Town town) async {
    _town = town;
    await _loadBundle(town);
  }

  Future<void> _loadBundle(Town town) async {
    final token = ++_loadToken;
    _bundleLoading = true;
    _bundleError = null;
    notifyListeners();
    try {
      final b = await _loader.load(town, bundle: assets);
      if (token != _loadToken) return;
      _bundle = b;
    } catch (e) {
      if (token != _loadToken) return;
      _bundle = null;
      _bundleError = e;
    }
    _bundleLoading = false;
    notifyListeners();
  }
}

/// Exposes [AppState] to the widget tree and rebuilds dependents on change.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope above this context');
    return scope!.notifier!;
  }
}
