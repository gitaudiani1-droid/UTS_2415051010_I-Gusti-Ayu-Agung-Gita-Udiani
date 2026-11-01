import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../repositories/workout_repository.dart';

class WorkoutProvider extends ChangeNotifier {
  final WorkoutRepository repository;

  WorkoutProvider({
    required this.repository,
  });

  List<Workout> _workouts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Workout> get workouts => _workouts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mengambil data workout
  Future<void> loadWorkouts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _workouts = await repository.getWorkouts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menambahkan workout
  Future<bool> addWorkout(Workout workout) async {
    try {
      _errorMessage = null;

      await repository.addWorkout(workout);
      await loadWorkouts();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Mengedit workout
  Future<bool> updateWorkout(Workout workout) async {
    try {
      _errorMessage = null;

      await repository.updateWorkout(workout);
      await loadWorkouts();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Menghapus workout
  Future<bool> deleteWorkout(int id) async {
    try {
      _errorMessage = null;

      await repository.deleteWorkout(id);
      await loadWorkouts();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
