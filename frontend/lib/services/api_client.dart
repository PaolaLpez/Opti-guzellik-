// lib/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_config.dart';
import '../utils/auth_storage.dart';

/// Excepción personalizada para errores HTTP y respuestas no exitosas.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic body;

  ApiException({
    required this.statusCode,
    required this.message,
    this.body,
  });

  @override
  String toString() => 'ApiException ($statusCode): $message';
}

/// Cliente HTTP centralizado para interceptar peticiones, inyectar el token Bearer
/// y procesar respuestas y errores de forma consistente.
class ApiClient {
  static String get baseUrl => AppConfig.apiBaseUrl;

  /// Inyección automática de cabeceras Authorization: Bearer <token>
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Manejo genérico de respuestas y errores de red (401, 403, 404, 500)
  static http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }

    String message = '';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['message'] != null) {
        message = decoded['message'].toString();
      } else if (decoded is Map && decoded['error'] != null) {
        message = decoded['error'].toString();
      }
    } catch (_) {
      // Si la respuesta no es un JSON parseable, se mantiene mensaje por defecto
    }

    switch (response.statusCode) {
      case 401:
        throw ApiException(
          statusCode: 401,
          message: message.isNotEmpty ? message : 'No autorizado (401). Sesión expirada o token inválido.',
          body: response.body,
        );
      case 403:
        throw ApiException(
          statusCode: 403,
          message: message.isNotEmpty ? message : 'Acceso denegado (403). No cuentas con permisos suficientes.',
          body: response.body,
        );
      case 404:
        throw ApiException(
          statusCode: 404,
          message: message.isNotEmpty ? message : 'Recurso no encontrado (404).',
          body: response.body,
        );
      case 500:
        throw ApiException(
          statusCode: 500,
          message: message.isNotEmpty ? message : 'Error interno del servidor (500). Inténtelo más tarde.',
          body: response.body,
        );
      default:
        if (response.statusCode > 500) {
          throw ApiException(
            statusCode: response.statusCode,
            message: message.isNotEmpty ? message : 'Error en el servidor (${response.statusCode}).',
            body: response.body,
          );
        }
        throw ApiException(
          statusCode: response.statusCode,
          message: message.isNotEmpty ? message : 'Error en la petición HTTP (${response.statusCode}).',
          body: response.body,
        );
    }
  }

  /// Método GET
  static Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  /// Método POST
  static Future<http.Response> post(String endpoint, dynamic data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// Método PUT
  static Future<http.Response> put(String endpoint, dynamic data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// Método PATCH
  static Future<http.Response> patch(String endpoint, dynamic data) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  /// Método DELETE
  static Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  /// Helper opcional para decodificar JSON a Map o List
  static dynamic decode(http.Response response) {
    return jsonDecode(response.body);
  }
}

/// Alias para cumplir con la nomenclatura ApiService
typedef ApiService = ApiClient;