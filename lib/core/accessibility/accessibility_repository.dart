import '../accessibility/accessibility_settings.dart';
import '../storage/preferences_storage.dart';

/// Repository for managing accessibility settings with persistence
class AccessibilityRepository {
  final PreferencesStorage _storage;

  AccessibilityRepository(this._storage);

  /// Get current accessibility settings from storage
  AccessibilitySettings getCurrent() {
    return AccessibilitySettings(
      largeText: _storage.getLargeText(),
      highContrast: _storage.getHighContrast(),
      simplifiedLayout: _storage.getEasyReading(),
    );
  }

  /// Update and persist accessibility settings
  Future<void> update(AccessibilitySettings settings) async {
    await _storage.setLargeText(settings.largeText);
    await _storage.setHighContrast(settings.highContrast);
    await _storage.setEasyReading(settings.simplifiedLayout);
  }
}
