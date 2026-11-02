import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/exercise_provider.dart';
import 'repositories/exercise_repository.dart';
import 'services/exercise_api_service.dart';
import 'providers/workout_provider.dart';
import 'repositories/workout_repository.dart';
import 'services/supabase_service.dart';
import 'providers/nutrition_provider.dart';
import 'repositories/nutrition_repository.dart';
import 'services/nutrition_service.dart';
import 'screens/main_navigation_screen.dart';
import 'providers/nutrition_goal_provider.dart';
import 'repositories/nutrition_goal_repository.dart';
import 'services/nutrition_goal_service.dart';
import 'theme/app_theme.dart';

class GlowFitApp extends StatelessWidget {
  const GlowFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExerciseProvider(
            repository: ExerciseRepository(
              apiService: ExerciseApiService(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => WorkoutProvider(
            repository: WorkoutRepository(
              supabaseService: SupabaseService(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NutritionProvider(
            repository: NutritionRepository(
              nutritionService: NutritionService(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NutritionGoalProvider(
            repository: NutritionGoalRepository(
              service: NutritionGoalService(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'GLOWFIT',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
