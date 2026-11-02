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

    final id = food.id;
    if (id == null) return;

    final success = await context
        .read<NutritionProvider>()
        .deleteFoodLog(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Food log berhasil dihapus!'
              : context.read<NutritionProvider>().errorMessage ??
              'Gagal menghapus food log.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        toolbarHeight:
        MediaQuery.of(context).orientation == Orientation.landscape
            ? 44
            : 56,
        title: const Text(
          'Nutrition Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFF4F8),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape =
              MediaQuery.of(context).orientation ==
                  Orientation.landscape;
          final isWide = constraints.maxWidth >= 700;
          final compact = isLandscape || isWide;

          return Consumer<NutritionProvider>(
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
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1100,
                    ),
                    child: ListView(
                      padding: EdgeInsets.all(compact ? 12 : 20),
                      children: [
                        Text(
                          'Your Daily Nutrition 💗',
                          style: TextStyle(
                            fontSize: compact ? 19 : 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF30283D),
                          ),
                        ),
                        SizedBox(height: compact ? 3 : 6),
                        Text(
                          'Pantau asupan nutrisi harianmu.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: compact ? 12 : 14,
                          ),
                        ),
                        SizedBox(height: compact ? 12 : 20),

                        if (compact)
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: _calorieCard(
                                  totalCalories,
                                  compact: true,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 5,
                                child: _macroSection(
                                  totalProtein,
                                  totalCarbs,
                                  totalFat,
                                  todayLogs.length,
                                  compact: true,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          _calorieCard(totalCalories),
                          const SizedBox(height: 20),
                          _macroSection(
                            totalProtein,
                            totalCarbs,
                            totalFat,
                            todayLogs.length,
                          ),
                        ],

                        SizedBox(height: compact ? 14 : 24),

                        SizedBox(
                          width: double.infinity,
                          height: compact ? 44 : 52,
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

                        SizedBox(height: compact ? 14 : 24),

                        Text(
                          "Today's Food Logs",
                          style: TextStyle(
                            fontSize: compact ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF30283D),
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (todayLogs.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Belum ada catatan makanan hari ini.',
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ...todayLogs.map(
                                (food) => _foodLogCard(food),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _calorieCard(
      double totalCalories, {
        bool compact = false,
      }) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Calories',
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 13 : 16,
            ),
          ),
          SizedBox(height: compact ? 6 : 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '${totalCalories.toStringAsFixed(0)} kcal',
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 25 : 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            'Total kalori yang dikonsumsi hari ini',
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 10 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroSection(
      double protein,
      double carbs,
      double fat,
      int foodCount, {
        bool compact = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Macronutrients',
          style: TextStyle(
            fontSize: compact ? 15 : 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF30283D),
          ),
        ),
        SizedBox(height: compact ? 8 : 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: compact ? 8 : 12,
          mainAxisSpacing: compact ? 8 : 12,
          childAspectRatio: compact ? 2.0 : 1.7,
          children: [
            _nutritionCard(
              'Protein',
              protein,
              'g',
              const Color(0xFFA99BEF),
              compact: compact,
            ),
            _nutritionCard(
              'Carbs',
              carbs,
              'g',
              const Color(0xFF5795F5),
              compact: compact,
            ),
            _nutritionCard(
              'Fat',
              fat,
              'g',
              const Color(0xFFF5A9C8),
              compact: compact,
            ),
            _nutritionCard(
              'Food Logs',
              foodCount.toDouble(),
              'items',
              const Color(0xFFA8E6CF),
              compact: compact,
            ),
          ],
        ),
      ],
    );
  }

  Widget _nutritionCard(
      String title,
      double value,
      String unit,
      Color color, {
        bool compact = false,
      }) {
    return Container(
      padding: EdgeInsets.all(compact ? 10 : 14),
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
            style: TextStyle(
              color: Colors.grey,
              fontSize: compact ? 11 : 13,
            ),
          ),
          SizedBox(height: compact ? 4 : 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '${value.toStringAsFixed(0)} $unit',
              style: TextStyle(
                color: color,
                fontSize: compact ? 16 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _foodLogCard(FoodLog food) {
    return Card(
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
    );
  }
}
