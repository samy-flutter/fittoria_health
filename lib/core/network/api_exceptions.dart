import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic responseData;

  ApiException({required this.message, this.statusCode, this.responseData});

  @override
  String toString() => message;

  factory ApiException.fromDioError(DioException error) {
    String message = 'Something went wrong';
    int? statusCode = error.response?.statusCode;
    dynamic data = error.response?.data;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout. Please try again.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout. Please try again.';
        break;
      case DioExceptionType.badResponse:
        if (statusCode != null) {
          if (statusCode == 400) {
            message = _getErrorMessage(data) ?? 'Invalid request details.';
          } else if (statusCode == 401) {
            message = 'Session expired. Please log in again.';
          } else if (statusCode == 403) {
            message = 'Access forbidden.';
          } else if (statusCode == 404) {
            message = 'Requested resource not found.';
          } else if (statusCode == 422) {
            message = _getErrorMessage(data) ?? 'Validation error occurred.';
          } else if (statusCode == 423) {
            message = 'Account temporarily locked due to too many failed attempts.';
          } else if (statusCode == 429) {
            final retrySec = data?['error']?['retryAfterSec'] ?? 900;
            final mins = (retrySec / 60).ceil();
            message = 'Too many attempts. Try again in $mins minute${mins != 1 ? "s" : ""}.';
          } else if (statusCode >= 500) {
            message = 'Internal server error. Please try again later.';
          }
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled.';
        break;
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        message = 'Network error. Please verify your connection.';
        break;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      responseData: data,
    );
  }

  static String? _getErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      if (data['error'] != null) {
        if (data['error'] is String) return data['error'];
        if (data['error'] is Map && data['error']['message'] != null) {
          return data['error']['message'];
        }
      }
      if (data['message'] != null) return data['message'];
    }
    return null;
  }
}
