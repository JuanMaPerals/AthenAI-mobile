import 'package:shared_preferences/shared_preferences.dart';

/// Central storage service for app preferences
/// ONLY stores non-sensitive data: accessibility settings, onboarding preferences
/// NEVER stores: tokens, passwords, email, name, message content
class PreferencesStorage {
  static const String _keyLargeText = 'accessibility_large_text';
  static const String _keyHighContrast = 'accessibility_high_contrast';
  static const String _keyEasyReading = 'accessibility_easy_reading';
  
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyUserMode = 'onboarding_user_mode';
  static const String _keyExplanationStyle = 'onboarding_explanation_style';

  static const String _keyBetaBannerDismissed = 'beta_banner_dismissed';

  // Singleton pattern
  static final PreferencesStorage _instance = PreferencesStorage._internal();
  factory PreferencesStorage() => _instance;
  PreferencesStorage._internal();

  SharedPreferences? _prefs;

  /// Initialize storage (must be called at app startup)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception('PreferencesStorage not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ============================================================================
  // Accessibility Settings
  // ============================================================================

  bool getLargeText() {
    return _preferences.getBool(_keyLargeText) ?? false;
  }

  Future<void> setLargeText(bool value) async {
    await _preferences.setBool(_keyLargeText, value);
  }

  bool getHighContrast() {
    return _preferences.getBool(_keyHighContrast) ?? false;
  }

  Future<void> setHighContrast(bool value) async {
    await _preferences.setBool(_keyHighContrast, value);
  }

  bool getEasyReading() {
    return _preferences.getBool(_keyEasyReading) ?? false;
  }

  Future<void> setEasyReading(bool value) async {
    await _preferences.setBool(_keyEasyReading, value);
  }

  // ============================================================================
  // Onboarding Preferences
  // ============================================================================

  bool getOnboardingCompleted() {
    return _preferences.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await _preferences.setBool(_keyOnboardingCompleted, value);
  }

  String? getUserMode() {
    return _preferences.getString(_keyUserMode);
  }

  Future<void> setUserMode(String value) async {
    await _preferences.setString(_keyUserMode, value);
  }

  String? getExplanationStyle() {
    return _preferences.getString(_keyExplanationStyle);
  }

  Future<void> setExplanationStyle(String value) async {
    await _preferences.setString(_keyExplanationStyle, value);
  }

  // ============================================================================
  // UI Preferences
  // ============================================================================

  bool getBetaBannerDismissed() {
    return _preferences.getBool(_keyBetaBannerDismissed) ?? false;
  }

  Future<void> setBetaBannerDismissed(bool value) async {
    await _preferences.setBool(_keyBetaBannerDismissed, value);
  }

  // ============================================================================
  // Bulk Operations
  // ============================================================================

  /// Clear all stored preferences (useful for testing or reset)
  Future<void> clearAll() async {
    await _preferences.clear();
  }
}
