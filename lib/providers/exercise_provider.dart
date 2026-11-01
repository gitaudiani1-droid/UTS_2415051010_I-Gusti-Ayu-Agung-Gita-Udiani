import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../repositories/exercise_repository.dart';

class ExerciseProvider extends ChangeNotifier {
  final ExerciseRepository repository;

  ExerciseProvider({
    required this.repository,
  });

  List<Exercise> _exercises = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadExercises() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _exercises = await repository.getExercises();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
