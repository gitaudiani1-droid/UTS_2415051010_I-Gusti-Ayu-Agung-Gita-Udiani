import '../models/food_log.dart';
import '../services/nutrition_service.dart';

class NutritionRepository {
  final NutritionService nutritionService;

  NutritionRepository({
    required this.nutritionService,
  });

  // Mengambil daftar makanan
  Future<List<FoodLog>> getFoodLogs() {
    return nutritionService.getFoodLogs();
  }

  // Menambahkan makanan
  Future<void> addFoodLog(FoodLog foodLog) {
    return nutritionService.addFoodLog(foodLog);
  }

  // Mengubah makanan
  Future<void> updateFoodLog(FoodLog foodLog) {
    return nutritionService.updateFoodLog(foodLog);
  }

  // Menghapus makanan
  Future<void> deleteFoodLog(int id) {
    return nutritionService.deleteFoodLog(id);
  }
}
