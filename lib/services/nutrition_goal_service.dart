import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/nutrition_goal.dart';

class NutritionGoalService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<NutritionGoal?> getNutritionGoal() async {
    final response = await _client
        .from('nutrition_goals')
        .select()
        .limit(1);

    if (response.isEmpty) {
      return null;
    }

    return NutritionGoal.fromJson(response.first);
  }

  Future<void> addNutritionGoal(NutritionGoal goal) async {
    await _client
        .from('nutrition_goals')
        .insert(goal.toJson());
  }

  Future<void> updateNutritionGoal(NutritionGoal goal) async {
    if (goal.id == null) {
      throw Exception('Nutrition Goal ID tidak ditemukan');
    }

    await _client
        .from('nutrition_goals')
        .update(goal.toJson())
        .eq('id', goal.id!);
  }
}
