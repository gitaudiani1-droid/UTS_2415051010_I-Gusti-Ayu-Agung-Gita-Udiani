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

  Widget _buildSearchField() {
    return TextField(
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
    );
  }

  Widget _buildBodyPartFilter(List<String> bodyParts) {
    return DropdownButtonFormField<String>(
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
    );
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
            return const Center(
              child: CircularProgressIndicator(),
            );
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

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth >= 600;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: isWideScreen ? 8 : 16,
                    ),
                    child: isWideScreen
                        ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildSearchField(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildBodyPartFilter(bodyParts),
                        ),
                      ],
                    )
                        : Column(
                      children: [
                        _buildSearchField(),
                        const SizedBox(height: 12),
                        _buildBodyPartFilter(bodyParts),
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
                      child: isWideScreen
                          ? GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3.2,
                        ),
                        itemCount: filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise =
                          filteredExercises[index];

                          return _buildExerciseCard(
                            context,
                            exercise,
                          );
                        },
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise =
                          filteredExercises[index];

                          return Padding(
                            padding:
                            const EdgeInsets.only(bottom: 12),
                            child: _buildExerciseCard(
                              context,
                              exercise,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, dynamic exercise) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${exercise.bodyPart} • ${exercise.equipment}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
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
  }
}
