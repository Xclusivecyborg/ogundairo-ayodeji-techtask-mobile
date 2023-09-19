import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:tech_task/core/config/response/app_response.dart';
import 'package:tech_task/core/utils/appurls.dart';
import 'package:tech_task/core/utils/strings.dart';
import 'package:tech_task/domain/repository/base_repository.dart';
import 'package:tech_task/domain/repository/base_repository_impl.dart';
import 'package:tech_task/features/ingredients/data/models/ingredient_model.dart';
import 'package:tech_task/features/recipes/data/models/recipe_model.dart';

import '../mock_data/mocks.dart';

void main() {
  late Dio _client;
  late DioAdapter dioAdapter;
  late BaseRepository _baseRepository;

  setUp(() {
    _client = Dio(BaseOptions(baseUrl: "https://www.google.com"));
    dioAdapter = DioAdapter(
      dio: _client,
      matcher: const FullHttpRequestMatcher(),
    );
    _baseRepository = BaseRepositoryImpl(_client);
  });

  group('Get Ingredients ==>', () {
    test(
        '''Test that endpoint returns a list of 2 ingredients with status code 200
         Test that response is of type SucccessResponse<List<Ingredient>>''',
        () async {
      dioAdapter.onGet(
        AppUrls.ingredients,
        (request) => request.reply(200, MockData.ingredientsResponse),
      );

      final response = await _baseRepository.getIngredients();
      expect(response, isA<SucccessResponse<List<Ingredient>>>());
      expect(response.data?.length, 3);
    });
    test('''Test that status code of 500 returns server error message
     Test that response is of type ErrorResponse<List<Ingredient>>''',
        () async {
      dioAdapter.onGet(
        AppUrls.ingredients,
        (request) => request.reply(500, null),
      );

      final response = await _baseRepository.getIngredients();

      expect(response, isA<ErrorResponse>());
      expect(response.message, Strings.serverError);
    });
  });
  group('Get Recipes ==>', () {
    test('''Test that endpoint returns a list of 2 recipes with status code 200
         Test that response is of type SucccessResponse<List<Recipe>>''',
        () async {
      dioAdapter.onGet(
        AppUrls.recipes + "?ingredients=${MockData.ingredients.join(",")}",
        (request) => request.reply(200, MockData.recipesResponse),
      );

      final response = await _baseRepository.getRecipes(MockData.ingredients);
      expect(response, isA<SucccessResponse<List<Recipe>>>());
      expect(response.data?.length, 2);
    });
    test('Test that wrong statuscode returns Error response and data is null',
        () async {
      dioAdapter.onGet(
        AppUrls.recipes,
        (request) => request.reply(400, {
          "message": "Invalid request",
          "data": null,
        }),
      );

      final response = await _baseRepository.getRecipes(MockData.ingredients);

      expect(response, isA<ErrorResponse>());
      expect(response.data, null);
    });
  });
}
