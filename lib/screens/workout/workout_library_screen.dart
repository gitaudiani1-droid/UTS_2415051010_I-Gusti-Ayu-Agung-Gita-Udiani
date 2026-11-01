import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exercise_provider.dart';
import 'exercise_detail_screen.dart';

class WorkoutLibraryScreen extends StatefulWidget {
  const WorkoutLibraryScreen({super.key});

  @override
  State<WorkoutLibraryScreen> createState() =>
      _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends State<WorkoutLibraryScreen> {
  String searchQuery = '';
  String selectedBodyPart = 'All';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().loadExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Library',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5A9C8),
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.exercises.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null &&
              provider.exercises.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.loadExercises,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final bodyParts = provider.exercises
              .map((exercise) => exercise.bodyPart)
              .where((part) => part.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

          final filteredExercises = provider.exercises.where((exercise) {
            final matchesSearch = exercise.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase());

            final matchesBodyPart = selectedBodyPart == 'All' ||
                exercise.bodyPart == selectedBodyPart;

            return matchesSearch && matchesBodyPart;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search exercises...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedBodyPart,
                      decoration: InputDecoration(
                        labelText: 'Filter by body part',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: 'All',
                          child: Text('All Body Parts'),
                        ),
                        ...bodyParts.map(
                              (part) => DropdownMenuItem(
                            value: part,
                            child: Text(part),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedBodyPart = value ?? 'All';
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredExercises.isEmpty
                    ? const Center(
                  child: Text('No exercises found.'),
                )
                    : RefreshIndicator(
                  onRefresh: provider.loadExercises,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFF5A9C8),
                            child: Icon(
                              Icons.fitness_center,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            exercise.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${exercise.bodyPart} • ${exercise.equipment}',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExerciseDetailScreen(
                                  exercise: exercise,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
