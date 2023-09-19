import 'package:flutter/material.dart';
import 'package:tech_task/core/utils/extensions.dart';
import 'package:tech_task/features/home/presentation/widgets/custom_platform_date_picker.dart';
import 'package:tech_task/features/ingredients/presentation/ingredients_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        height: mediaQuery.height,
        width: mediaQuery.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/recipe.jpg',
                fit: BoxFit.fill,
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Recipes',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white, shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.white,
                          offset: Offset(5.0, 5.0),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    CustomPlatformDatePicker(
                      onDateChanged: (date) {
                        selectedDate = date;
                      },
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: MediaQuery.sizeOf(context).height * 0.07,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            IngredientsPage(
                              selectedDate: selectedDate,
                            ).slideRoute(),
                          ),
                          child: Text(
                            'Tap to Get Ingredients',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
