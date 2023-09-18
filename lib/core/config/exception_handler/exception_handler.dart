import 'package:dio/dio.dart';
import 'package:tech_task/core/config/response/app_response.dart';
import 'package:tech_task/core/config/logger.dart';
import 'package:tech_task/core/utils/strings.dart';

class AppException implements Exception {
  static AppResponse<T> handleException<T>(
    DioException e, {
    T? data,
  }) {
    debugLog(e);
    if (e.response != null && DioExceptionType.badResponse == e.type) {
      if (e.response!.statusCode! >= 500) {
        final error = ErrorResponse(
          status: false,
          message: Strings.serverError,
          data: data,
        );
        debugLog(error.message);
        return error;
      }
    }
    return ErrorResponse(
      status: false,
      data: data,
      message: _mapException(e.type),
    );
  }

  static String _mapException(DioExceptionType? error) {
    if (DioExceptionType.connectionTimeout == error ||
        DioExceptionType.receiveTimeout == error ||
        DioExceptionType.sendTimeout == error) {
      return Strings.timeout;
    } else if (DioExceptionType.unknown == error) {
      return Strings.connectionError;
    }
    return Strings.genericErrorMessage;
  }
}
