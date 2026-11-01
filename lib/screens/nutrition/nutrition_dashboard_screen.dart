import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../models/food_log.dart';
import 'food_form_screen.dart';

class NutritionDashboardScreen extends StatefulWidget {
  const NutritionDashboardScreen({super.key});

  @override
  State<NutritionDashboardScreen> createState() =>
      _NutritionDashboardScreenState();
}

class _NutritionDashboardScreenState
    extends State<NutritionDashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NutritionProvider>().loadFoodLogs();
    });
  }

  Future<void> _openFoodForm({FoodLog? food}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodFormScreen(food: food),
      ),
    );

    if (!mounted) return;
    await context.read<NutritionProvider>().loadFoodLogs();
  }

  Future<void> _deleteFood(FoodLog food) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Food Log?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${food.foodName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await context
        .read<NutritionProvider>()
        .deleteFoodLog(food.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Food log berhasil dihapus!'
              : context.read<NutritionProvider>().errorMessage ??
              'Gagal menghapus food log.',
        ),
        backgroundColor:
        success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        title: const Text(
          'Nutrition Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFF4F8),
        elevation: 0,
      ),
      body: Consumer<NutritionProvider>(
        builder: (context, provider, child) {
          final today = DateTime.now();

          final todayLogs = provider.foodLogs.where((food) {
            return food.consumedAt.year == today.year &&
                food.consumedAt.month == today.month &&
                food.consumedAt.day == today.day;
          }).toList();

          final totalCalories = todayLogs.fold<double>(
            0,
                (sum, food) => sum + food.calories,
          );

          final totalProtein = todayLogs.fold<double>(
            0,
                (sum, food) => sum + food.protein,
          );

          final totalCarbs = todayLogs.fold<double>(
            0,
                (sum, food) => sum + food.carbohydrates,
          );

          final totalFat = todayLogs.fold<double>(
            0,
                (sum, food) => sum + food.fat,
          );

          if (provider.isLoading && provider.foodLogs.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null &&
              provider.foodLogs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(provider.errorMessage!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: provider.loadFoodLogs,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadFoodLogs,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Your Daily Nutrition 💗',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF30283D),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pantau asupan nutrisi harianmu.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Total Calories
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF5A9C8),
                        Color(0xFFA99BEF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Calories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${totalCalories.toStringAsFixed(0)} kcal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Total kalori yang dikonsumsi hari ini',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Macronutrients',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF30283D),
                  ),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.7,
                  children: [
                    _nutritionCard(
                      'Protein',
                      totalProtein,
                      'g',
                      const Color(0xFFA99BEF),
                    ),
                    _nutritionCard(
                      'Carbs',
                      totalCarbs,
                      'g',
                      const Color(0xFF5795F5),
                    ),
                    _nutritionCard(
                      'Fat',
                      totalFat,
                      'g',
                      const Color(0xFFF5A9C8),
                    ),
                    _nutritionCard(
                      'Food Logs',
                      todayLogs.length.toDouble(),
                      'items',
                      const Color(0xFFA8E6CF),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _openFoodForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Food'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFFF5A9C8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Today's Food Logs",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF30283D),
                  ),
                ),
                const SizedBox(height: 12),

                if (todayLogs.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Belum ada catatan makanan hari ini.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...todayLogs.map(
                        (food) => Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFE1EC),
                          child: Icon(
                            Icons.restaurant,
                            color: Color(0xFFF5A9C8),
                          ),
                        ),
                        title: Text(
                          food.foodName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${food.mealType} • '
                              '${food.protein.toStringAsFixed(0)}g protein',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${food.calories.toStringAsFixed(0)} kcal',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _openFoodForm(food: food);
                                } else if (value == 'delete') {
                                  _deleteFood(food);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 18),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Hapus'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _nutritionCard(
      String title,
      double value,
      String unit,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${value.toStringAsFixed(0)} $unit',
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
