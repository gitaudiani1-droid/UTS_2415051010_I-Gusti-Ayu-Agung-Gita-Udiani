import '../models/nutrition_goal.dart';
import '../services/nutrition_goal_service.dart';

class NutritionGoalRepository {
  final NutritionGoalService _service;

  NutritionGoalRepository({
    required this._service,
  });

  Future<NutritionGoal?> getNutritionGoal() {
    return _service.getNutritionGoal();
  }

  Future<void> addNutritionGoal(NutritionGoal goal) {
    return _service.addNutritionGoal(goal);
  }

  Future<void> updateNutritionGoal(NutritionGoal goal) {
    return _service.updateNutritionGoal(goal);
  }
}
