// lib/features/auth/domain/auth_session.dart

/// Authentication session containing access and refresh tokens
///
/// SECURITY NOTE: This session is stored IN MEMORY ONLY.
/// Tokens are NOT persisted to disk or SharedPreferences.
///
/// When the app is closed, the session is lost and the user must
/// re-authenticate. This is intentional for security until we implement
/// secure encrypted storage with the ZITADEL integration.
class AuthSession {
  /// JWT access token for API requests
  final String accessToken;

  /// Refresh token for obtaining new access tokens
  final String refreshToken;

  /// Expiration time of the access token
  final DateTime? expiresAt;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  /// Check if the access token has expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if the access token is still valid
  bool get isValid => !isExpired;
}
