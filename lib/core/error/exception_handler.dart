import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'failures.dart';
import '../network/api_exceptions.dart';

class ExceptionHandler {
  static Failure handle(dynamic error) {
    if (error is ApiException) {
      return ServerFailure(error.message);
    } else if (error is DioException) {
      final apiException = ApiException.fromDioError(error);
      return ServerFailure(apiException.message);
    } else {
      // Log the actual error internally (e.g. TypeError, json mapping error)
      debugPrint('Unhandled Exception: $error');
      
      // Return a clean, generic message to the user
      return ServerFailure('Something went wrong processing the data. Please try again.');
    }
  }
}
