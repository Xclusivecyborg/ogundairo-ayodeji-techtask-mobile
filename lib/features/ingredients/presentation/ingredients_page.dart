import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_task/core/utils/enums.dart';
import 'package:tech_task/core/utils/extensions.dart';
import 'package:tech_task/features/ingredients/data/models/ingredient_model.dart';
import 'package:tech_task/features/ingredients/presentation/notifier/ingredients_notifier.dart';
import 'package:tech_task/features/ingredients/presentation/widgets/ingredient_tile.dart';
import 'package:tech_task/features/recipes/presentation/recipes_page.dart';
import 'package:tech_task/presentation/general_widgets/general_app_bar.dart';

class IngredientsPage extends ConsumerStatefulWidget {
  const IngredientsPage({
    super.key,
    required this.selectedDate,
  });
  final DateTime selectedDate;

  @override
  ConsumerState<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends ConsumerState<IngredientsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(ingredientsNotifier.notifier).getIngredients();
  }

  @override
  Widget build(BuildContext context) {
    final LoadState loadState = ref.watch(
        ingredientsNotifier.select((value) => value.getIngredientsState));
    final String? error =
        ref.watch(ingredientsNotifier.select((value) => value.errorMessage));
    final List<Ingredient> ingredients =
        ref.watch(ingredientsNotifier.select((value) => value.ingredients));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: switch (loadState) {
            LoadState.loading =>
              const Center(child: CircularProgressIndicator.adaptive()),
            LoadState.error => Center(child: Text(error ?? 'Error')),
            _ => Column(
                children: [
                  GeneralAppBar(title: 'Ingredients'),
                  _getIngredientsView(ingredients),
                ],
              ),
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _getRecipesButton(context),
    );
  }

  Expanded _getIngredientsView(List<Ingredient> ingredients) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: 100),
        separatorBuilder: (context, index) => const SizedBox(
          height: 30,
        ),
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          bool isAvailable = widget.selectedDate
                  .difference(ingredients[index].useBy.toDateTime)
                  .inDays <
              0;
          return IngredientTile(
            ingredient: ingredients[index],
            isAvailable: isAvailable,
          );
        },
      ),
    );
  }

  Consumer _getRecipesButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        bool isEnabled = ref
            .watch(ingredientsNotifier
                .select((value) => value.selectedIngredients))
            .isNotEmpty;
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: FloatingActionButton(
            backgroundColor: isEnabled ? Colors.white : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {
              if (!isEnabled) return;
              Navigator.push(
                context,
                RecipesPage().slideRoute(),
              );
            },
            child: Text(
              'Tap to get Recipes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isEnabled ? Colors.black : Colors.white,
                  ),
            ),
          ),
        );
      },
    );
  }
}
