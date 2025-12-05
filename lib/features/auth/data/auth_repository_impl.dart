// lib/features/auth/data/auth_repository_impl.dart

import '../domain/auth_repository.dart';
import '../domain/auth_session.dart';
import 'auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthSession? _currentSession;

  AuthRepositoryImpl(this._apiService);

  @override
  AuthSession? get currentSession => _currentSession;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final session = await _apiService.login(
      email: email,
      password: password,
    );
    _currentSession = session;
    return session;
  }

  @override
  void setSession(AuthSession session) {
    _currentSession = session;
  }

  @override
  void logout() {
    _currentSession = null;
  }
}
