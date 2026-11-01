class Workout {
  final int? id;
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;
  final int durationMinutes;
  final DateTime workoutDate;

  Workout({
    this.id,
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.durationMinutes,
    required this.workoutDate,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      exerciseName: json['exercise_name'] ?? '',
      muscleGroup: json['muscle_group'] ?? '',
      sets: json['sets'] ?? 0,
      reps: json['reps'] ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      durationMinutes: json['duration_minutes'] ?? 0,
      workoutDate: DateTime.parse(json['workout_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise_name': exerciseName,
      'muscle_group': muscleGroup,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration_minutes': durationMinutes,
      'workout_date': workoutDate.toIso8601String(),
    };
  }
}
