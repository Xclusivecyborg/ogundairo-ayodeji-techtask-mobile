import 'package:equatable/equatable.dart';
import 'package:tech_task/core/utils/strings.dart';

abstract class AppResponse<T> extends Equatable {
  final String message;
  final T? data;

  AppResponse({
    required this.message,
    this.data,
  });
}

class SucccessResponse<T> extends AppResponse<T> {
  SucccessResponse({
    required String message,
    T? data,
  }) : super(
          message: message,
          data: data,
        );

  factory SucccessResponse.fromJson(Map<String, dynamic> json) {
    return SucccessResponse(
      message: json['message'] as String,
      data: json['data'] as T?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
    };
  }

  @override
  List<Object?> get props => [message, data];
}

class ErrorResponse<T> extends AppResponse<T> {
  ErrorResponse({
    required String message,
    T? data,
  }) : super(
          message: message,
          data: data,
        );

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] ?? Strings.genericErrorMessage,
      data: json['data'] as T?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
    };
  }

  @override
  List<Object?> get props => [message, data];
}
