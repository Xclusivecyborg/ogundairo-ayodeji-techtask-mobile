import 'package:equatable/equatable.dart';
import 'package:tech_task/core/utils/strings.dart';

abstract class AppResponse<T> extends Equatable {
  final String message;
  final bool status;
  final T? data;

  AppResponse({
    required this.message,
    required this.status,
    this.data,
  });
}

class SucccessResponse<T> extends AppResponse<T> {
  SucccessResponse({
    required String message,
    required bool status,
    T? data,
  }) : super(
          message: message,
          status: status,
          data: data,
        );

  factory SucccessResponse.fromJson(Map<String, dynamic> json) {
    return SucccessResponse(
      message: json['message'] as String,
      status: json['status'] as bool,
      data: json['data'] as T?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'data': data,
    };
  }

  @override
  List<Object?> get props => [message, status, data];
}

class ErrorResponse<T> extends AppResponse<T> {
  ErrorResponse({
    required String message,
    required bool status,
    T? data,
  }) : super(
          message: message,
          status: status,
          data: data,
        );

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] ?? Strings.genericErrorMessage,
      status: json['status'] ?? false,
      data: json['data'] as T?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'data': data,
    };
  }

  @override
  List<Object?> get props => [message, status, data];
}
