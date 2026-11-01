import 'package:flutter/material.dart';
import 'workout_library_screen.dart';
import 'workout_history_screen.dart';
import 'workout_form_screen.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF4F8),
        appBar: AppBar(
          title: const Text(
            'My Workout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFF5A9C8),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.fitness_center),
                text: 'Library',
              ),
              Tab(
                icon: Icon(Icons.history),
                text: 'History',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WorkoutLibraryScreen(),
            WorkoutHistoryScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFFF5A9C8),
          foregroundColor: const Color(0xFF30283D),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkoutFormScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Workout'),
        ),
      ),
    );
  }
}
