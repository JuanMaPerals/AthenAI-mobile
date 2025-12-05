// lib/features/auth/domain/auth_repository.dart

import 'auth_session.dart';

abstract class AuthRepository {
  AuthSession? get currentSession;

  Future<AuthSession> login({
    required String email,
    required String password,
  });

  void setSession(AuthSession session);

  void logout();
}
