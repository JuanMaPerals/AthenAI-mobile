// lib/features/auth/domain/auth_repository.dart

import 'auth_session.dart';

/// Repository for managing authentication state
///
/// Authentication state is stored in MEMORY ONLY for security.
/// The session is lost when the app is closed, requiring re-login.
///
/// Future enhancements may include:
/// - Persistent encrypted session storage
/// - Token refresh with automatic re-authentication
/// - Biometric unlock for stored credentials
abstract class AuthRepository {
  /// Current authentication session, or null if not authenticated
  AuthSession? get currentSession;

  /// Check if user is currently authenticated
  bool get isAuthenticated => currentSession != null;

  /// Login with email and password
  Future<AuthSession> login({
    required String email,
    required String password,
  });

  /// Set the current session (used for demo mode and future OAuth flows)
  void setSession(AuthSession session);

  /// Logout and clear the current session
  void logout();
}
