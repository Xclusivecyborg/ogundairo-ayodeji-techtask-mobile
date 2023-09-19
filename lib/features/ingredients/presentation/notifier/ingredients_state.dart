import 'package:equatable/equatable.dart';

import 'package:tech_task/core/utils/enums.dart';
import 'package:tech_task/features/ingredients/data/models/ingredient_model.dart';
import 'package:tech_task/features/recipes/data/models/recipe_model.dart';

class IngredientsNotifierState extends Equatable {
  final LoadState getIngredientsState;
  final LoadState getRecipesState;
  final List<Ingredient> ingredients;
  final List<Recipe> recipes;
  final List<String> selectedIngredients;
  final String? errorMessage;
  IngredientsNotifierState({
    required this.getIngredientsState,
    required this.ingredients,
    this.errorMessage,
    required this.selectedIngredients,
    required this.recipes,
    required this.getRecipesState,
  });
  factory IngredientsNotifierState.initial() {
    return IngredientsNotifierState(
      getIngredientsState: LoadState.loading,
      ingredients: const [],
      selectedIngredients: const [],
      recipes: const [],
      getRecipesState: LoadState.loading,
    );
  }
  IngredientsNotifierState copyWith({
    LoadState? getIngredientsState,
    List<Ingredient>? ingredients,
    String? errorMessage,
    List<String>? selectedIngredients,
    List<Recipe>? recipes,
    LoadState? getRecipesState,
  }) {
    return IngredientsNotifierState(
      getIngredientsState: getIngredientsState ?? this.getIngredientsState,
      ingredients: ingredients ?? this.ingredients,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      recipes: recipes ?? this.recipes,
      getRecipesState: getRecipesState ?? this.getRecipesState,
    );
  }

  @override
  List<Object?> get props => [
        getIngredientsState,
        ingredients,
        errorMessage,
        selectedIngredients,
        recipes,
        getRecipesState,
      ];
}
