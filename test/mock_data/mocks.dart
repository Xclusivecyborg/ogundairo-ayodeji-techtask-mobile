import 'package:mocktail/mocktail.dart';
import 'package:tech_task/domain/repository/base_repository.dart';

class MockBaseRepository extends Mock implements BaseRepository {}

class MockData {
  static List<Map<String, dynamic>> ingredientsResponse = [
    {
      'title': 'Cheese',
      'use-by': '2023-11-11',
    },
    {
      'title': 'Ham',
      'use-by': '2023-10-10',
    },
    {
      'title': 'Burger',
      'use-by': '2020-10-10',
    },
  ];

  static List<String> ingredients = [
    "Ham",
    "Cheese",
  ];

  static List<Map<String, dynamic>> recipesResponse = [
    {
      'title': 'Ham and Cheese Toastie',
      'ingredients': [
        'Ham',
        'Cheese',
        'Bread',
        'Butter',
      ],
    },
    {
      'title': 'Salad',
      'ingredients': [
        'Lettuce',
        'Tomato',
        'Cucumber',
        'Beetroot',
      ],
    },
  ];
}
