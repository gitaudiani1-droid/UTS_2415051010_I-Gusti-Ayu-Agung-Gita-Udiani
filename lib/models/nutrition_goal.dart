class NutritionGoal {
  final int? id;
  final double dailyCalories;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;

  NutritionGoal({
    this.id,
    required this.dailyCalories,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
  });

  factory NutritionGoal.fromJson(Map<String, dynamic> json) {
    return NutritionGoal(
      id: json['id'],
      dailyCalories:
      (json['daily_calories'] as num?)?.toDouble() ?? 0,
      proteinGoal:
      (json['protein_goal'] as num?)?.toDouble() ?? 0,
      carbsGoal:
      (json['carbs_goal'] as num?)?.toDouble() ?? 0,
      fatGoal:
      (json['fat_goal'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_calories': dailyCalories,
      'protein_goal': proteinGoal,
      'carbs_goal': carbsGoal,
      'fat_goal': fatGoal,
    };
  }
}
