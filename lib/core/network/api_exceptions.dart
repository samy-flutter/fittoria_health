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
        message = 'We couldn\'t connect to the server. Please check your internet connection and try again.';
        break;
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'The server took too long to respond. Please try again.';
        break;
      case DioExceptionType.badResponse:
        if (statusCode != null) {
          if (statusCode == 400) {
            message = _getErrorMessage(data) ?? 'There was a problem with your request. Please check your details.';
          } else if (statusCode == 401) {
            message = _getErrorMessage(data) ?? 'Your session has expired. Please log in again to continue.';
          } else if (statusCode == 403) {
            message = 'You do not have permission to access this.';
          } else if (statusCode == 404) {
            message = 'The requested information could not be found.';
          } else if (statusCode == 422) {
            message = _getErrorMessage(data) ?? 'Please check the information you provided and try again.';
          } else if (statusCode == 423) {
            message = 'Your account is temporarily locked due to too many failed attempts. Please try again later.';
          } else if (statusCode == 429) {
            final retrySec = data?['error']?['retryAfterSec'] ?? 900;
            final mins = (retrySec / 60).ceil();
            message = 'You\'ve made too many attempts. Please try again in $mins minute${mins != 1 ? "s" : ""}.';
          } else if (statusCode >= 500) {
            message = _getErrorMessage(data) ?? 'Our servers are currently experiencing issues. Please try again later.';
          }
        }
        break;
      case DioExceptionType.cancel:
        message = 'The request was cancelled.';
        break;
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        message = 'A network error occurred. Please verify your internet connection.';
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
