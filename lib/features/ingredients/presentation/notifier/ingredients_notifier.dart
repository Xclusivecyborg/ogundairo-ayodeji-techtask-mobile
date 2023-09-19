import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_task/core/config/response/app_response.dart';
import 'package:tech_task/core/utils/enums.dart';
import 'package:tech_task/domain/repository/base_repository.dart';
import 'package:tech_task/domain/repository/base_repository_impl.dart';
import 'package:tech_task/features/ingredients/presentation/notifier/ingredients_state.dart';

class IngredientsNotifier extends StateNotifier<IngredientsNotifierState> {
  IngredientsNotifier(this._baseRepository)
      : super(IngredientsNotifierState.initial());
  final BaseRepository _baseRepository;

  Future<void> getIngredients() async {
    try {
      final response = await _baseRepository.getIngredients();
      if (response is ErrorResponse) throw response.message;
      state = state.copyWith(
        getIngredientsState: LoadState.success,
        ingredients: response.data,
      );
    } catch (e) {
      state = state.copyWith(
        getIngredientsState: LoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> getRecipes() async {
    try {
      final response =
          await _baseRepository.getRecipes(state.selectedIngredients);
      if (response is ErrorResponse) throw response.message;
      state = state.copyWith(
        getRecipesState: LoadState.success,
        recipes: response.data,
      );
    } catch (e) {
      state = state.copyWith(
        getRecipesState: LoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  void selectIngredient(String ingredient) {
    List<String> selectedIngredients = [...state.selectedIngredients];
    if (selectedIngredients.contains(ingredient)) {
      selectedIngredients.remove(ingredient);
    } else {
      selectedIngredients.add(ingredient);
    }
    state = state.copyWith(
      selectedIngredients: selectedIngredients,
    );
  }
}

final ingredientsNotifier = StateNotifierProvider.autoDispose<
    IngredientsNotifier, IngredientsNotifierState>(
  (_) => IngredientsNotifier(_.read(baseRepositoryProvider)),
);
