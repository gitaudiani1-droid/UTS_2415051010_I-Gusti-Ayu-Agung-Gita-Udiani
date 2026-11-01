import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../widgets/summary_card.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigate;

  const HomeScreen({
    super.key,
    this.onNavigate,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().loadWorkouts();
      context.read<NutritionProvider>().loadFoodLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final date =
        '${now.day}/${now.month}/${now.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      body: SafeArea(
        child: Consumer2<WorkoutProvider, NutritionProvider>(
          builder: (context, workoutProvider, nutritionProvider, child) {
            final todayWorkouts =
                workoutProvider.workouts.where((workout) {
                  return workout.workoutDate.year == now.year &&
                      workout.workoutDate.month == now.month &&
                      workout.workoutDate.day == now.day;
                }).length;

            final todayCalories =
            nutritionProvider.foodLogs
                .where((food) =>
            food.consumedAt.year == now.year &&
                food.consumedAt.month == now.month &&
                food.consumedAt.day == now.day)
                .fold<double>(
              0,
                  (sum, food) => sum + food.calories,
            );

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello, Gita! 👋',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF30283D),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          date,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFFFFE1EC),
                      child: Icon(
                        Icons.favorite,
                        color: Color(0xFFF5A9C8),
                        size: 27,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Welcome card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF5A9C8),
                        Color(0xFFA99BEF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Glow Strong, Feel Beautiful ✨',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Small progress is still progress. '
                            'Keep moving and take care of yourself!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Today's Overview",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF30283D),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Workouts Today',
                        value: todayWorkouts.toString(),
                        subtitle: 'Keep it up!',
                        icon: Icons.fitness_center,
                        color: const Color(0xFFA99BEF),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: 'Calories Today',
                        value: todayCalories.toStringAsFixed(0),
                        subtitle: 'kcal consumed',
                        icon: Icons.local_fire_department,
                        color: const Color(0xFFF5A9C8),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF30283D),
                  ),
                ),

                const SizedBox(height: 15),

                _quickAccessCard(
                  title: 'Workout Tracker',
                  subtitle: 'Manage your exercise activities',
                  icon: Icons.fitness_center,
                  color: const Color(0xFFA99BEF),
                  onTap: () {
                    widget.onNavigate?.call(1);
                  },
                ),

                const SizedBox(height: 12),

                _quickAccessCard(
                  title: 'Nutrition Tracker',
                  subtitle: 'Track your daily food and calories',
                  icon: Icons.restaurant,
                  color: const Color(0xFFF5A9C8),
                  onTap: () {
                    widget.onNavigate?.call(2);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _quickAccessCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
