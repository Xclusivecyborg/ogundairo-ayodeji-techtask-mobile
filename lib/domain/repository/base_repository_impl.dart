import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_task/core/config/response/app_response.dart';
import 'package:tech_task/core/config/exception_handler/exception_handler.dart';
import 'package:tech_task/core/utils/appurls.dart';
import 'package:tech_task/domain/repository/base_repository.dart';
import 'package:tech_task/features/ingredients/data/models/ingredient_model.dart';
import 'package:tech_task/features/recipes/data/models/recipe_model.dart';

class BaseRepositoryImpl extends BaseRepository {
  final Dio _client;
  BaseRepositoryImpl(this._client);
  @override
  Future<AppResponse<List<Ingredient>>> getIngredients() async {
    try {
      final response = await _client.get(
        AppUrls.ingredients,
      );
      List<Ingredient> ingredients = List<Ingredient>.from(
          response.data.map((x) => Ingredient.fromJson(x)));
      return SucccessResponse(
        data: ingredients,
        message: "Success",
      );
    } on DioException catch (e) {
      return AppException.handleException(e);
    }
  }

  @override
  Future<AppResponse<List<Recipe>>> getRecipes(List<String> ingredients) async {
    String joinedIngredients = ingredients.join(",");
    try {
      final response = await _client.get(
        '${AppUrls.recipes}?ingredients=$joinedIngredients',
      );
      List<Recipe> recipes =
          List<Recipe>.from(response.data.map((x) => Recipe.fromJson(x)));
      return SucccessResponse(
        data: recipes,
        message: "Success",
      );
    } on DioException catch (e) {
      return AppException.handleException(e);
    }
  }
}

final baseRepositoryProvider = Provider<BaseRepository>((ref) {
  final dio = Dio();
  dio.options.baseUrl = AppUrls.baseUrl;
  return BaseRepositoryImpl(dio);
});
