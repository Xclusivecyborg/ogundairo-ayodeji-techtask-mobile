import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_task/core/config/response/app_response.dart';
import 'package:tech_task/core/utils/enums.dart';
import 'package:tech_task/core/utils/strings.dart';
import 'package:tech_task/domain/repository/base_repository.dart';
import 'package:tech_task/domain/repository/base_repository_impl.dart';
import 'package:tech_task/features/ingredients/data/models/ingredient_model.dart';
import 'package:tech_task/features/ingredients/presentation/notifier/ingredients_notifier.dart';

import '../mock_data/mocks.dart';

void main() {
  late BaseRepository _baseRepository;
  setUpAll(() {
    _baseRepository = MockBaseRepository();
  });

  group('Ingredients Notifier Test ==>', () {
    test('''Test that when response is SuccessResponse, ingredients is not empty
         and getIngredients state equals LoadState.success''', () async {
      final container = ProviderContainer(
        overrides: [
          baseRepositoryProvider.overrideWithValue(_baseRepository),
        ],
      );
      when(() => _baseRepository.getIngredients()).thenAnswer(
        (_) async => SucccessResponse(
          data: MockData.ingredientsResponse.map(Ingredient.fromJson).toList(),
          message: 'Successful',
        ),
      );
      final notifier = container.read(ingredientsNotifier.notifier);
      await notifier.getIngredients();
      final state = container.read(ingredientsNotifier);
      expect(state.ingredients.isEmpty, false);
      expect(state.getIngredientsState, LoadState.success);
    });
    test('''Test that when response is ErrorResponse, ingredients is empty,
          getIngredients state equals LoadState.error and errorMessage is not Null''',
        () async {
      final container = ProviderContainer(
        overrides: [
          baseRepositoryProvider.overrideWithValue(_baseRepository),
        ],
      );
      when(() => _baseRepository.getIngredients()).thenAnswer(
        (_) async => ErrorResponse(
          message: Strings.genericErrorMessage,
        ),
      );
      final notifier = container.read(ingredientsNotifier.notifier);
      await notifier.getIngredients();
      final state = container.read(ingredientsNotifier);
      expect(state.ingredients.isEmpty, true);
      expect(state.getIngredientsState, LoadState.error);
      expect(state.errorMessage, isNot(null));
    });
  });
}
