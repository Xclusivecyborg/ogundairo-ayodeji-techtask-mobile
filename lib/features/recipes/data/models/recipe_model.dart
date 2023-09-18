import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String title;
  final List<String> ingredients;

  Recipe({
    required this.title,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        title: json["title"] as String,
        ingredients: List<String>.from(json["ingredients"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
      };

  @override
  List<Object> get props => [title, ingredients];
}
