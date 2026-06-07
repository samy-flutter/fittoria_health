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
      return UnknownFailure(error.toString());
    }
  }
}
