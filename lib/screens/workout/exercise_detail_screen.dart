import 'package:flutter/material.dart';
import '../../models/exercise.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        title: const Text('Exercise Detail'),
        backgroundColor: const Color(0xFFF5A9C8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xFFE9DFFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: exercise.imageUrl != null &&
                  exercise.imageUrl!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  exercise.imageUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.fitness_center,
                      size: 80,
                      color: Color(0xFFA99BEF),
                    );
                  },
                ),
              )
                  : const Icon(
                Icons.fitness_center,
                size: 80,
                color: Color(0xFFA99BEF),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30283D),
              ),
            ),
            const SizedBox(height: 16),

            _buildInfoCard(
              'Body Part',
              exercise.bodyPart,
              Icons.accessibility_new,
            ),
            _buildInfoCard(
              'Target Muscle',
              exercise.target.isEmpty ? 'Not specified' : exercise.target,
              Icons.sports_gymnastics,
            ),
            _buildInfoCard(
              'Equipment',
              exercise.equipment.isEmpty
                  ? 'No equipment specified'
                  : exercise.equipment,
              Icons.fitness_center,
            ),

            const SizedBox(height: 24),
            const Text(
              'Instructions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30283D),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                exercise.instructions.isEmpty
                    ? 'No instructions available.'
                    : exercise.instructions,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF30283D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFA99BEF)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
