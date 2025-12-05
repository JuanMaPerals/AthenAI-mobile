import '../../features/auth/data/auth_api_service.dart';
import '../../features/auth/data/auth_repository_impl.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/settings/data/profile_api_service.dart';
import '../config/environment.dart';
import '../../features/onboarding/data/onboarding_preferences_repository.dart';
import '../../features/consent/data/consent_repository.dart';
import '../../features/reviews/data/reviews_repository.dart';
import '../storage/preferences_storage.dart';
import '../accessibility/accessibility_repository.dart';

/// Simple service locator for dependency injection
/// In production, consider using get_it, provider, or riverpod
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Singleton instances
  AuthRepository? _authRepository;
  AuthApiService? _authApiService;
  ProfileApiService? _profileApiService;
  OnboardingPreferencesRepository? _onboardingPreferencesRepository;
  ConsentRepository? _consentRepository;
  ReviewsRepository? _reviewsRepository;
  PreferencesStorage? _preferencesStorage;
  AccessibilityRepository? _accessibilityRepository;

  /// Get or create the auth repository instance
  AuthRepository get authRepository {
    _authRepository ??= AuthRepositoryImpl(authApiService);
    return _authRepository!;
  }

  /// Get or create the auth API service instance
  AuthApiService get authApiService {
    _authApiService ??= AuthApiService(baseUrl: Environment.apiBaseUrl);
    return _authApiService!;
  }

  /// Get or create the profile API service instance
  ProfileApiService get profileApiService {
    _profileApiService ??= ProfileApiService(baseUrl: Environment.apiBaseUrl);
    return _profileApiService!;
  }

  /// Get the preferences storage instance
  /// Must be initialized before use with initPreferencesStorage()
  PreferencesStorage get preferencesStorage {
    if (_preferencesStorage == null) {
      throw Exception('PreferencesStorage not initialized. Call initPreferencesStorage() first.');
    }
    return _preferencesStorage!;
  }

  /// Initialize preferences storage (must be called at app startup)
  Future<void> initPreferencesStorage() async {
    _preferencesStorage = PreferencesStorage();
    await _preferencesStorage!.init();
  }

  /// Get or create the accessibility repository instance
  AccessibilityRepository get accessibilityRepository {
    _accessibilityRepository ??= AccessibilityRepository(preferencesStorage);
    return _accessibilityRepository!;
  }

  /// Get or create the onboarding preferences repository instance
  OnboardingPreferencesRepository get onboardingPreferencesRepository {
    _onboardingPreferencesRepository ??= OnboardingPreferencesRepository(preferencesStorage);
    return _onboardingPreferencesRepository!;
  }

  /// Get or create the consent repository instance
  ConsentRepository get consentRepository {
    _consentRepository ??= ConsentRepository();
    return _consentRepository!;
  }

  /// Get or create the reviews repository instance
  ReviewsRepository get reviewsRepository {
    _reviewsRepository ??= ReviewsRepository();
    return _reviewsRepository!;
  }

  /// Reset all services (useful for logout)
  void reset() {
    _authRepository = null;
    _authApiService = null;
    _profileApiService = null;
    // We intentionally don't reset onboarding/consent preferences on logout as they might be device-specific
  }
}
