// lib/features/auth/domain/auth_session.dart

class AuthSession {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });
}
