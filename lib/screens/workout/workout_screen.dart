import 'package:flutter/material.dart';
import 'workout_library_screen.dart';
import 'workout_history_screen.dart';
import 'workout_form_screen.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  void _openWorkoutForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WorkoutFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF4F8),
        appBar: AppBar(
          toolbarHeight: isLandscape ? 44 : 56,
          title: Text(
            'My Workout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isLandscape ? 18 : 22,
            ),
          ),
          backgroundColor: const Color(0xFFF5A9C8),
          actions: [
            IconButton(
              tooltip: 'Add Workout',
              onPressed: () => _openWorkoutForm(context),
              icon: Icon(
                Icons.add_circle_outline,
                size: isLandscape ? 22 : 26,
              ),
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(isLandscape ? 48 : 64),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.symmetric(
                vertical: isLandscape ? 0 : 6,
              ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.fitness_center,
                    size: isLandscape ? 18 : 24,
                  ),
                  text: 'Library',
                  height: isLandscape ? 46 : 64,
                ),
                Tab(
                  icon: Icon(
                    Icons.history,
                    size: isLandscape ? 18 : 24,
                  ),
                  text: 'History',
                  height: isLandscape ? 46 : 64,
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            WorkoutLibraryScreen(),
            WorkoutHistoryScreen(),
          ],
        ),
      ),
    );
  }
}
