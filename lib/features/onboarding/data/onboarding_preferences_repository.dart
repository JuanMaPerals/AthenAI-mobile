import '../../../core/storage/preferences_storage.dart';
import '../domain/onboarding_preferences.dart';
import '../domain/user_mode.dart';

/// Repository to manage onboarding preferences with persistence
class OnboardingPreferencesRepository {
  final PreferencesStorage _storage;

  OnboardingPreferencesRepository(this._storage);

  /// Gets the current preferences from storage
  OnboardingPreferences get current {
    final completed = _storage.getOnboardingCompleted();
    final userModeStr = _storage.getUserMode();
    final explanationStyleStr = _storage.getExplanationStyle();

    // Parse user mode
    UserMode userMode = UserMode.individual;
    if (userModeStr != null) {
      try {
        userMode = UserMode.values.firstWhere((m) => m.name == userModeStr);
      } catch (_) {
        // Default to individual if parsing fails
      }
    }

    // Parse explanation style
    ExplanationStyle explanationStyle = ExplanationStyle.stepByStep;
    if (explanationStyleStr != null) {
      try {
        explanationStyle = ExplanationStyle.values.firstWhere((s) => s.name == explanationStyleStr);
      } catch (_) {
        // Default to stepByStep if parsing fails
      }
    }

    return OnboardingPreferences(
      isCompleted: completed,
      userMode: userMode,
      explanationStyle: explanationStyle,
    );
  }

  /// Updates and persists the preferences
  Future<void> update(OnboardingPreferences updated) async {
    await _storage.setOnboardingCompleted(updated.isCompleted);
    await _storage.setUserMode(updated.userMode.name);
    await _storage.setExplanationStyle(updated.explanationStyle.name);
  }
}
