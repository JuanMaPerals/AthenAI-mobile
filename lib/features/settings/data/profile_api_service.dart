import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/environment.dart';
import '../../../core/di/service_locator.dart';
import '../../auth/data/auth_api_service.dart';
import '../domain/models/profile.dart';

/// Exception thrown when the Profile API call fails
class ProfileApiException implements Exception {
  final String code;
  final String message;
  final int? statusCode;

  ProfileApiException(
    this.code,
    this.message, {
    this.statusCode,
  });

  @override
  String toString() => 'ProfileApiException($code): $message';

  String get userMessage => message;
}

/// Service for communicating with the PersalOne Profile API
class ProfileApiService {
  final http.Client _client;
  final String _baseUrl;

  ProfileApiService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? Environment.apiBaseUrl;

  /// Fetch user profile from the API
  /// Throws ProfileApiException on errors
  /// Throws AuthException if session expired or not authenticated
  Future<Profile> fetchProfile() async {
    // Get current session from AuthRepository
    final authRepo = ServiceLocator().authRepository;
    final session = authRepo.currentSession;
    
    if (session == null) {
      throw AuthException('Tu sesión ha caducado. Por favor, inicia sesión de nuevo.');
    }

    final url = Uri.parse('$_baseUrl/profile');

    try {
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session.accessToken}',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw ProfileApiException(
            'timeout',
            'La solicitud tardó demasiado. Por favor, verifica tu conexión e intenta de nuevo.',
          );
        },
      );

      // Handle 401 Unauthorized - session expired
      if (response.statusCode == 401) {
        throw AuthException('SESSION_EXPIRED');
      }

      // Handle error responses
      if (response.statusCode >= 400) {
        return _handleErrorResponse(response);
      }

      // Parse successful response
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return Profile.fromJson(jsonResponse);
    } on http.ClientException {
      throw ProfileApiException(
        'network_error',
        'No se pudo conectar con el servidor. Verifica tu conexión a internet.',
      );
    } on FormatException {
      throw ProfileApiException(
        'parse_error',
        'No se pudo entender la respuesta del servidor.',
      );
    } catch (e) {
      if (e is ProfileApiException) rethrow;
      if (e is AuthException) rethrow;
      throw ProfileApiException(
        'unknown_error',
        'No se pudo cargar tu perfil. Por favor, intenta de nuevo.',
      );
    }
  }

  /// Handle error responses from the API
  Profile _handleErrorResponse(http.Response response) {
    try {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      final errorCode = errorBody['error'] as String? ?? 'unknown_error';

      throw ProfileApiException(
        errorCode,
        'No se pudo cargar tu perfil. Por favor, intenta de nuevo.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ProfileApiException) rethrow;

      // Fallback error if we can't parse the error response
      throw ProfileApiException(
        'http_error',
        'Error del servidor (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
