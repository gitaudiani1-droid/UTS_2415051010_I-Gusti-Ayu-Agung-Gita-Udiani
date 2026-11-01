import '../models/workout.dart';
import '../services/supabase_service.dart';

class WorkoutRepository {
  final SupabaseService supabaseService;

  WorkoutRepository({
    required this.supabaseService,
  });

  // Mengambil daftar workout
  Future<List<Workout>> getWorkouts() async {
    return await supabaseService.getWorkouts();
  }

  // Menambahkan workout
  Future<void> addWorkout(Workout workout) async {
    await supabaseService.addWorkout(workout);
  }

  // Mengubah workout
  Future<void> updateWorkout(Workout workout) async {
    await supabaseService.updateWorkout(workout);
  }

  // Menghapus workout
  Future<void> deleteWorkout(int id) async {
    await supabaseService.deleteWorkout(id);
  }
}
