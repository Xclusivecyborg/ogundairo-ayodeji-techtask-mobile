import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_task/core/config/response/app_response.dart';
import 'package:tech_task/core/utils/strings.dart';
import 'package:tech_task/domain/repository/base_repository_impl.dart';
import 'package:tech_task/features/home/presentation/home_page.dart';
import 'package:tech_task/features/home/presentation/widgets/custom_platform_date_picker.dart';
import 'package:tech_task/features/ingredients/data/models/ingredient_model.dart';
import 'package:tech_task/features/ingredients/presentation/ingredients_page.dart';
import 'package:tech_task/features/recipes/data/models/recipe_model.dart';
import 'package:tech_task/features/recipes/presentation/recipes_page.dart';
import 'package:tech_task/main.dart';
import 'package:tech_task/presentation/general_widgets/general_app_bar.dart';
import 'mock_data/mocks.dart';

void main() {
  testWidgets('End to End Test - Case Successful Response from Endpoints',
      (WidgetTester tester) async {
    final _baseRepository = MockBaseRepository();

    when(() => _baseRepository.getRecipes(MockData.ingredients)).thenAnswer(
      (_) async => SucccessResponse(
        data: MockData.recipesResponse.map(Recipe.fromJson).toList(),
        message: 'Successful',
      ),
    );

    when(() => _baseRepository.getIngredients()).thenAnswer(
      (_) async => SucccessResponse(
        data: MockData.ingredientsResponse.map(Ingredient.fromJson).toList(),
        message: 'Successful',
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
        overrides: [
          baseRepositoryProvider.overrideWithValue(_baseRepository),
        ],
      ),
    );

    // expects to see Homescreen and CustomPlatformDatePicker
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(CustomPlatformDatePicker), findsOneWidget);

    //tap get ingredients button to navigate to ingredients page
    await tester.tap(
      find.descendant(
        of: find.byType(HomePage),
        matching: find.byKey(Key(Strings.ingredientsButton)),
      ),
    );

    // expects to see ingredients page loaded on navigation
    await tester.pumpAndSettle();
    expect(find.byType(IngredientsPage), findsOneWidget);

    // expects to see GeneralAppBar on ingredients page
    expect(find.byType(GeneralAppBar), findsOneWidget);

    // expects to see List of Ingredients on ingredients page
    expect(
      find.descendant(
        of: find.byType(IngredientsPage),
        matching: find.byKey(Key(Strings.ingredientsList)),
      ),
      findsOneWidget,
    );

    // tap to select Burger with use-by date before current date'
    await tester.tap(
      find.descendant(
        of: find.byType(IngredientsPage),
        matching: find.byKey(ValueKey("Burger")),
      ),
    );

    // expects to see snackbar with message 'Ingredient is not available'
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(Strings.ingredientUnavailable), findsOneWidget);

    // tap to select cheese and ham
    await tester.tap(
      find.descendant(
        of: find.byType(IngredientsPage),
        matching: find.byKey(ValueKey("Ham")),
      ),
    );
    await tester.tap(
      find.descendant(
        of: find.byType(IngredientsPage),
        matching: find.byKey(ValueKey('Cheese')),
      ),
    );

    // tap 'Get Recipes' button to navigate to Recipes Page
    await tester.pumpAndSettle();
    await tester.tap(find.text(Strings.tapTogetRecipes));

    // expects to see RecipesScreen on navigation
    await tester.pumpAndSettle();
    expect(find.byType(RecipesPage), findsOneWidget);

    // expects to see GeneralAppBar on recipes page
    expect(find.byType(GeneralAppBar), findsOneWidget);

    //expects to see  Recipes List loaded on screen
    expect(find.byKey(Key(Strings.recipesList)), findsOneWidget);
  });

  testWidgets('End to End Test - Case Error Response from Endpoints',
      (WidgetTester tester) async {
    final _baseRepository = MockBaseRepository();

    when(() => _baseRepository.getRecipes(MockData.ingredients)).thenAnswer(
      (_) async => ErrorResponse(
        message: Strings.serverError,
      ),
    );

    when(() => _baseRepository.getIngredients()).thenAnswer(
      (_) async => ErrorResponse(
        message: Strings.serverError,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
        overrides: [
          baseRepositoryProvider.overrideWithValue(_baseRepository),
        ],
      ),
    );

    // expects to see Homescreen and CustomPlatformDatePicker
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(CustomPlatformDatePicker), findsOneWidget);

    //tap get ingredients button to navigate to ingredients page
    await tester.tap(
      find.descendant(
        of: find.byType(HomePage),
        matching: find.byKey(Key(Strings.ingredientsButton)),
      ),
    );

    // expects to see ingredients page loaded on navigation
    await tester.pumpAndSettle();
    expect(find.byType(IngredientsPage), findsOneWidget);

    // expects to see error message on ingredients page
    expect(find.text(Strings.serverError), findsOneWidget);

    //confirm that list of ingredients is not loaded
    expect(
      find.descendant(
        of: find.byType(IngredientsPage),
        matching: find.byKey(Key(Strings.ingredientsList)),
      ),
      findsNothing,
    );
  });
}
