// lib/features/agent/data/agent_api_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/config/environment.dart';
import '../../../core/di/service_locator.dart';
import '../../auth/data/auth_api_service.dart';
import '../domain/ally_message_response_v2.dart';

/// Exception thrown when Agent API calls fail
class AgentApiException implements Exception {
  final String code;
  final String message;
  final int? statusCode;
  final String? details;

  AgentApiException(
    this.code,
    this.message, {
    this.statusCode,
    this.details,
  });

  @override
  String toString() {
    return 'AgentApiException($code): $message${details != null ? ' - $details' : ''}';
  }

  /// User-friendly error message for display
  String get userMessage {
    return message;
  }
}

/// Service for communicating with the PersalOne AI Ally API
class AgentApiService {
  final http.Client _client;
  final String baseUrl;

  AgentApiService({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? Environment.apiBaseUrl;

  /// Send a message to the AI Ally and get a response (V2 format)
  ///
  /// Uses the /ally/message endpoint
  /// Returns AllyMessageResponseV2 with structured analysis
  /// Throws AgentApiException for errors
  /// Throws AuthException if session expired or not authenticated
  ///
  /// User preferences:
  /// - [userMode]: "individual", "caregiver", or "team" - defines the user's context
  /// - [explanationStyle]: "stepByStep" or "concise" - preferred explanation style
  /// - [easyReading]: true = prefer step-by-step format, shorter sentences, clear structure
  /// - [urls]: List of URLs extracted from the message for future WebCheck integration
  Future<AllyMessageResponseV2> sendMessage({
    required String message,
    String? conversationId,
    String language = 'es',
    String? mode,
    String platform = 'flutter',
    String appVersion = '1.0.0',
    // User preferences from onboarding and accessibility
    String? userMode,
    String? explanationStyle,
    String? focusArea,
    bool? easyReading,
    // URLs extracted from message for future WebCheck integration
    List<String>? urls,
  }) async {
    // Get current session from AuthRepository
    final authRepo = ServiceLocator().authRepository;
    final session = authRepo.currentSession;
    
    if (session == null) {
      throw AuthException('Tu sesión ha caducado. Por favor, inicia sesión de nuevo.');
    }

    final uri = Uri.parse('$baseUrl/ally/message');

    final requestBody = {
      'message': message,
      'context': {
        'platform': platform,
        'client': 'persalone',
        'env': 'dev',
        if (conversationId != null) 'conversationId': conversationId,
        if (mode != null) 'mode': mode,
        'language': language,
        'appVersion': appVersion,
        // Include user preferences if provided
        if (userMode != null) 'userMode': userMode,
        if (explanationStyle != null) 'explanationStyle': explanationStyle,
        if (focusArea != null) 'focusArea': focusArea,
        if (easyReading != null) 'easyReading': easyReading,
        // Include URLs for future WebCheck integration
        if (urls != null && urls.isNotEmpty) 'urls': urls,
      },
    };

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer ${session.accessToken}',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      // Handle successful response
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return AllyMessageResponseV2.fromJson(json);
      }

      // Handle 401 Unauthorized - session expired
      if (response.statusCode == 401) {
        throw AuthException('SESSION_EXPIRED');
      }

      // Handle 400 Bad Request
      if (response.statusCode == 400) {
        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          final errorCode = json['error'] as String?;
          
          if (errorCode == 'message_is_required') {
            throw AgentApiException(
              errorCode ?? 'bad_request',
              'El mensaje no puede estar vacío.',
              statusCode: response.statusCode,
            );
          }
        } catch (e) {
          if (e is AgentApiException) rethrow;
          if (e is AuthException) rethrow;
          // Fall through to generic error
        }
      }

      // Handle other HTTP errors
      throw AgentApiException(
        'http_error',
        'Error del servidor (${response.statusCode}). Por favor, intenta de nuevo.',
        statusCode: response.statusCode,
      );
    } on SocketException {
      // Network connection error
      throw AgentApiException(
        'network_error',
        'No se pudo conectar con el servidor. Verifica tu conexión a internet.',
      );
    } on TimeoutException {
      // Request timeout
      throw AgentApiException(
        'timeout',
        'La solicitud tardó demasiado. Por favor, verifica tu conexión e intenta de nuevo.',
      );
    } on http.ClientException catch (e) {
      // HTTP client error
      throw AgentApiException(
        'network_error',
        'No se pudo conectar con el servidor. Verifica tu conexión a internet.',
        details: e.toString(),
      );
    } on FormatException catch (e) {
      // JSON parsing error
      throw AgentApiException(
        'parse_error',
        'No se pudo entender la respuesta del servidor.',
        details: e.toString(),
      );
    } catch (e) {
      // Re-throw known exceptions
      if (e is AgentApiException) rethrow;
      if (e is AuthException) rethrow;
      
      // Unknown error
      throw AgentApiException(
        'unknown_error',
        'Ocurrió un error inesperado. Por favor, intenta de nuevo.',
        details: e.toString(),
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
