import 'package:flutter/material.dart';
import '../models/food_log.dart';
import '../repositories/nutrition_repository.dart';

class NutritionProvider extends ChangeNotifier {
  final NutritionRepository repository;

  NutritionProvider({
    required this.repository,
  });

  List<FoodLog> _foodLogs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FoodLog> get foodLogs => _foodLogs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // READ
  Future<void> loadFoodLogs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _foodLogs = await repository.getFoodLogs();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE
  Future<bool> addFoodLog(FoodLog foodLog) async {
    try {
      await repository.addFoodLog(foodLog);
      await loadFoodLogs();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // UPDATE
  Future<bool> updateFoodLog(FoodLog foodLog) async {
    try {
      await repository.updateFoodLog(foodLog);
      await loadFoodLogs();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // DELETE
  Future<bool> deleteFoodLog(int id) async {
    try {
      await repository.deleteFoodLog(id);
      await loadFoodLogs();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
