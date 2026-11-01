import '../models/exercise.dart';
import '../services/exercise_api_service.dart';

class ExerciseRepository {
  final ExerciseApiService apiService;

  ExerciseRepository({
    required this.apiService,
  });

  Future<List<Exercise>> getExercises() async {
    return await apiService.fetchExercises();
  }
}
