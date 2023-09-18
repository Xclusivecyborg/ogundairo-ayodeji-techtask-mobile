import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String title;
  final String useBy;

  Ingredient({
    required this.title,
    required this.useBy,
  });

  @override
  List<Object?> get props => [title, useBy];

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      title: json['title'] as String,
      useBy: json['use-by'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'use-by': useBy,
    };
  }
}
