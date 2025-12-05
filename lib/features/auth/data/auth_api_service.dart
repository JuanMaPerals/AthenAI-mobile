// lib/features/auth/data/auth_api_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../domain/auth_session.dart';

class AuthException implements Exception {
  final String userMessage;

  AuthException(this.userMessage);

  @override
  String toString() => 'AuthException($userMessage)';
}

class NetworkAuthException extends AuthException {
  NetworkAuthException()
      : super(
            'No se ha podido conectar con el servidor. Inténtalo de nuevo más tarde.');
}

class AuthApiService {
  final http.Client _client;
  final String _baseUrl;

  AuthApiService({
    http.Client? client,
    required String baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      // Handle successful response
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        final accessToken = json['accessToken'] as String?;
        final refreshToken = json['refreshToken'] as String?;
        final expiresIn = json['expiresIn'] as int?;

        if (accessToken == null || refreshToken == null) {
          throw AuthException('Respuesta de autenticación no válida.');
        }

        final expiresAt = expiresIn != null
            ? DateTime.now().add(Duration(seconds: expiresIn))
            : null;

        return AuthSession(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresAt: expiresAt,
        );
      }

      // Handle 400 Bad Request
      if (response.statusCode == 400) {
        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          if (json['error'] == 'email_and_password_required') {
            throw AuthException('Se requieren email y contraseña.');
          }
        } catch (e) {
          if (e is AuthException) rethrow;
          // Fall through to generic error
        }
      }

      // Handle other HTTP errors
      throw AuthException(
        'No se ha podido iniciar sesión. Revisa tus datos e inténtalo de nuevo.',
      );
    } on SocketException {
      // Network connection error
      throw NetworkAuthException();
    } on TimeoutException {
      // Request timeout
      throw AuthException(
        'La solicitud tardó demasiado. Por favor, verifica tu conexión e intenta de nuevo.',
      );
    } on http.ClientException {
      // HTTP client error
      throw NetworkAuthException();
    } on FormatException {
      // JSON parsing error
      throw AuthException(
        'Respuesta de autenticación no válida.',
      );
    } catch (e) {
      // Re-throw AuthException
      if (e is AuthException) rethrow;
      
      // Unknown error
      throw AuthException(
        'No se ha podido iniciar sesión. Revisa tus datos e inténtalo de nuevo.',
      );
    }
  }
}
