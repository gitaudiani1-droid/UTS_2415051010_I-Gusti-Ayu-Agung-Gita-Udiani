import 'package:flutter/material.dart';
import '../models/nutrition_goal.dart';
import '../repositories/nutrition_goal_repository.dart';

class NutritionGoalProvider extends ChangeNotifier {
  final NutritionGoalRepository _repository;

  NutritionGoalProvider({
    required this._repository,
  });

  NutritionGoal? _goal;
  bool _isLoading = false;
  String? _errorMessage;

  NutritionGoal? get goal => _goal;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadNutritionGoal() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _goal = await _repository.getNutritionGoal();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveNutritionGoal(NutritionGoal goal) async {
    _errorMessage = null;

    try {
      if (goal.id == null) {
        await _repository.addNutritionGoal(goal);
      } else {
        await _repository.updateNutritionGoal(goal);
      }

      await loadNutritionGoal();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
