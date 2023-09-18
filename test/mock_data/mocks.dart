

class MockData {
  static List<Map<String, dynamic>> ingredientsResponse = [
    {
      'title': 'Cheese',
      'use-by': '1997-11-11',
    },
    {
      'title': 'Ham',
      'use-by': '1997-10-10',
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
