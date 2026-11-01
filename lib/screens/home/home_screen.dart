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
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    final date = '${now.day}/${now.month}/${now.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      body: SafeArea(
        child: Consumer2<WorkoutProvider, NutritionProvider>(
          builder: (context, workoutProvider, nutritionProvider, child) {
            final todayWorkouts = workoutProvider.workouts.where((workout) {
              return workout.workoutDate.year == now.year &&
                  workout.workoutDate.month == now.month &&
                  workout.workoutDate.day == now.day;
            }).length;

            final todayCalories = nutritionProvider.foodLogs
                .where((food) =>
            food.consumedAt.year == now.year &&
                food.consumedAt.month == now.month &&
                food.consumedAt.day == now.day)
                .fold<double>(
              0,
                  (sum, food) => sum + food.calories,
            );

            final horizontalPadding =
            isLandscape ? 16.0 : 20.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: ListView(
                  padding: EdgeInsets.all(horizontalPadding),
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Gita! 👋',
                              style: TextStyle(
                                fontSize: isLandscape ? 19 : 23,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF30283D),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              date,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: isLandscape ? 20 : 25,
                          backgroundColor: const Color(0xFFFFE1EC),
                          child: Icon(
                            Icons.favorite,
                            color: const Color(0xFFF5A9C8),
                            size: isLandscape ? 22 : 27,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isLandscape ? 14 : 25),

                    if (isLandscape && screenWidth >= 700)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildWelcomeCard(isLandscape),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverview(
                              todayWorkouts,
                              todayCalories,
                              isLandscape,
                            ),
                          ),
                        ],
                      )
                    else ...[
                      _buildWelcomeCard(isLandscape),
                      SizedBox(height: isLandscape ? 14 : 25),
                      _buildOverview(
                        todayWorkouts,
                        todayCalories,
                        isLandscape,
                      ),
                    ],

                    SizedBox(height: isLandscape ? 16 : 25),

                    Text(
                      'Quick Access',
                      style: TextStyle(
                        fontSize: isLandscape ? 17 : 19,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF30283D),
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (isLandscape)
                      Row(
                        children: [
                          Expanded(
                            child: _quickAccessCard(
                              title: 'Workout Tracker',
                              subtitle: 'Manage your exercise activities',
                              icon: Icons.fitness_center,
                              color: const Color(0xFFA99BEF),
                              onTap: () => widget.onNavigate?.call(1),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _quickAccessCard(
                              title: 'Nutrition Tracker',
                              subtitle: 'Track your daily food and calories',
                              icon: Icons.restaurant,
                              color: const Color(0xFFF5A9C8),
                              onTap: () => widget.onNavigate?.call(2),
                            ),
                          ),
                        ],
                      )
                    else ...[
                      _quickAccessCard(
                        title: 'Workout Tracker',
                        subtitle: 'Manage your exercise activities',
                        icon: Icons.fitness_center,
                        color: const Color(0xFFA99BEF),
                        onTap: () => widget.onNavigate?.call(1),
                      ),
                      const SizedBox(height: 12),
                      _quickAccessCard(
                        title: 'Nutrition Tracker',
                        subtitle: 'Track your daily food and calories',
                        icon: Icons.restaurant,
                        color: const Color(0xFFF5A9C8),
                        onTap: () => widget.onNavigate?.call(2),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(bool isLandscape) {
    return Container(
      padding: EdgeInsets.all(isLandscape ? 16 : 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF5A9C8),
            Color(0xFFA99BEF),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Glow Strong, Feel Beautiful ✨',
            style: TextStyle(
              color: Colors.white,
              fontSize: isLandscape ? 16 : 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Small progress is still progress. '
                'Keep moving and take care of yourself!',
            style: TextStyle(
              color: Colors.white,
              fontSize: isLandscape ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(
      int todayWorkouts,
      double todayCalories,
      bool isLandscape,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Overview",
          style: TextStyle(
            fontSize: isLandscape ? 17 : 19,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF30283D),
          ),
        ),
        const SizedBox(height: 12),
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
      ],
    );
  }
}
