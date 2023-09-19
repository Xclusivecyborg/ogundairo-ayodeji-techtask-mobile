import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_task/core/utils/extensions.dart';
import 'package:tech_task/core/utils/strings.dart';
import 'package:tech_task/features/ingredients/data/models/ingredient_model.dart';
import 'package:tech_task/features/ingredients/presentation/notifier/ingredients_notifier.dart';
import 'package:tech_task/presentation/general_widgets/animated_tile_holder.dart';

class IngredientTile extends ConsumerWidget {
  const IngredientTile({
    super.key,
    required this.ingredient,
    required this.isAvailable,
  });
  final Ingredient ingredient;
  final bool isAvailable;

  @override
  Widget build(BuildContext context, ref) {
    return AnimatedTileHolder(
      onTap: (value) {
        value
          ..reset()
          ..forward(from: 0.8);
        if (!isAvailable) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text(
                Strings.ingredientUnavailable,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.blueGrey,
            ),
          );
          return;
        }
        ref
            .read(ingredientsNotifier.notifier)
            .selectIngredient(ingredient.title);
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/ingredient.jpg',
                  fit: BoxFit.fill,
                ).blurImage,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  ingredient.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 3,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        switch (isAvailable) {
                          true => 'Available',
                          false => 'Not Available',
                        },
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              if (isAvailable)
                Consumer(
                  builder: (context, ref, _) {
                    final isSelected = ref
                        .watch(ingredientsNotifier.select(
                          (value) => value.selectedIngredients,
                        ))
                        .contains(ingredient.title);
                    return Align(
                      alignment: Alignment.topRight,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, anim) {
                          return ScaleTransition(
                            scale: anim,
                            child: child,
                          );
                        },
                        child: switch (isSelected) {
                          true => _getContainer(
                              color: Colors.white,
                              child: Icon(
                                Icons.check,
                                color: Colors.black,
                              ),
                            ),
                          _ => _getContainer(color: Colors.white10),
                        },
                      ),
                    );
                  },
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.white : Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        ingredient.useBy.toDateTime.formattedDate,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _getContainer({
    Widget? child,
    Color? color,
  }) {
    return Container(
      height: 35,
      width: 35,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(right: 10, top: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
