import 'package:tech_task/core/config/response/app_response.dart';
import 'package:tech_task/features/ingredients/data/models/ingredient_model.dart';
import 'package:tech_task/features/recipes/data/models/recipe_model.dart';

abstract class BaseRepository {
  Future<AppResponse<List<Ingredient>>> getIngredients();
  Future<AppResponse<List<Recipe>>> getRecipes(List<String> ingredients);
}
