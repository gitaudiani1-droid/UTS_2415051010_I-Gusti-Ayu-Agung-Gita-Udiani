import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_log.dart';

class NutritionService {
  final SupabaseClient _client = Supabase.instance.client;

  // READ: Mengambil semua catatan makanan
  Future<List<FoodLog>> getFoodLogs() async {
    final response = await _client
        .from('food_logs')
        .select()
        .order('consumed_at', ascending: false);

    return response
        .map<FoodLog>((item) => FoodLog.fromJson(item))
        .toList();
  }

  // CREATE: Menambahkan catatan makanan
  Future<void> addFoodLog(FoodLog foodLog) async {
    await _client.from('food_logs').insert(foodLog.toJson());
  }

  // UPDATE: Mengubah catatan makanan
  Future<void> updateFoodLog(FoodLog foodLog) async {
    if (foodLog.id == null) {
      throw Exception('Food Log ID tidak ditemukan');
    }

    await _client
        .from('food_logs')
        .update(foodLog.toJson())
        .eq('id', foodLog.id!);
  }

  // DELETE: Menghapus catatan makanan
  Future<void> deleteFoodLog(int id) async {
    await _client
        .from('food_logs')
        .delete()
        .eq('id', id);
  }
}
