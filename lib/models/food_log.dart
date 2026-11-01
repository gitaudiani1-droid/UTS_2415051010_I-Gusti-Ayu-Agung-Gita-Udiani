class FoodLog {
  final int? id;
  final String foodName;
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final String mealType;
  final DateTime consumedAt;

  FoodLog({
    this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.mealType,
    required this.consumedAt,
  });

  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: json['id'],
      foodName: json['food_name'] ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0,
      carbohydrates:
      (json['carbohydrates'] as num?)?.toDouble() ?? 0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0,
      mealType: json['meal_type'] ?? '',
      consumedAt: DateTime.parse(json['consumed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_name': foodName,
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'meal_type': mealType,
      'consumed_at': consumedAt.toIso8601String(),
    };
  }
}
