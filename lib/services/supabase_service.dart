import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/workout.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Menambahkan workout
  Future<void> addWorkout(Workout workout) async {
    await _client.from('workouts').insert(workout.toJson());
  }

  // Mengambil semua workout
  Future<List<Workout>> getWorkouts() async {
    final response = await _client
        .from('workouts')
        .select()
        .order('workout_date', ascending: false);

    return response
        .map<Workout>(
          (item) => Workout.fromJson(item),
    )
        .toList();
  }

  // Mengubah workout
  Future<void> updateWorkout(Workout workout) async {
    if (workout.id == null) {
      throw Exception('Workout ID tidak ditemukan');
    }

    await _client
        .from('workouts')
        .update(workout.toJson())
        .eq('id', workout.id!);
  }

  // Menghapus workout
  Future<void> deleteWorkout(int id) async {
    await _client.from('workouts').delete().eq('id', id);
  }
}
