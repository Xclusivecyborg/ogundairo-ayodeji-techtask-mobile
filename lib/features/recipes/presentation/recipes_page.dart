import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_task/core/utils/enums.dart';
import 'package:tech_task/core/utils/strings.dart';
import 'package:tech_task/features/ingredients/presentation/notifier/ingredients_notifier.dart';
import 'package:tech_task/features/recipes/data/models/recipe_model.dart';
import 'package:tech_task/features/recipes/presentation/widgets/recipe_tile.dart';
import 'package:tech_task/presentation/general_widgets/general_app_bar.dart';

class RecipesPage extends ConsumerStatefulWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref.read(ingredientsNotifier.notifier).getRecipes();
    });
  }

  Expanded _getRecipesView(List<Recipe> recipes) {
    return Expanded(
      child: ListView.separated(
        key: Key(Strings.recipesList),
        padding: EdgeInsets.only(bottom: 100),
        separatorBuilder: (context, index) => const SizedBox(
          height: 30,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeTile(
            recipe: recipes[index],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoadState loadState =
        ref.watch(ingredientsNotifier.select((value) => value.getRecipesState));
    final String? error =
        ref.watch(ingredientsNotifier.select((value) => value.errorMessage));
    final List<Recipe> recies =
        ref.watch(ingredientsNotifier.select((value) => value.recipes));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: switch (loadState) {
            LoadState.loading =>
              const Center(child: CircularProgressIndicator.adaptive()),
            LoadState.error =>
              Center(child: Text(error ?? Strings.genericErrorMessage)),
            _ => Column(
                children: [
                  GeneralAppBar(title: Strings.recipes),
                  _getRecipesView(recies),
                ],
              ),
          },
        ),
      ),
    );
  }
}
