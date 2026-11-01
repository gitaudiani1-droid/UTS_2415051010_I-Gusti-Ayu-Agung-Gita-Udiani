import 'package:flutter/material.dart';
import '../../models/workout.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';

class WorkoutFormScreen extends StatefulWidget {
  final Workout? workout;

  const WorkoutFormScreen({
    super.key,
    this.workout,
  });

  @override
  State<WorkoutFormScreen> createState() =>
      _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  @override
  void initState() {
    super.initState();

    final workout = widget.workout;

    if (workout != null) {
      _exerciseController.text = workout.exerciseName;
      _muscleController.text = workout.muscleGroup;
      _setsController.text = workout.sets.toString();
      _repsController.text = workout.reps.toString();
      _weightController.text = workout.weight.toString();
      _durationController.text =
          workout.durationMinutes.toString();
      selectedDate = workout.workoutDate;
    }
  }
  final _formKey = GlobalKey<FormState>();

  final _exerciseController = TextEditingController();
  final _muscleController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _durationController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _exerciseController.dispose();
    _muscleController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }



  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final workout = Workout(
      exerciseName: _exerciseController.text.trim(),
      muscleGroup: _muscleController.text.trim(),
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
      weight: double.parse(_weightController.text),
      durationMinutes: int.parse(_durationController.text),
      workoutDate: selectedDate,
    );

    try {
      final success = widget.workout == null
          ? await context.read<WorkoutProvider>().addWorkout(workout)
          : await context.read<WorkoutProvider>().updateWorkout(
        Workout(
          id: widget.workout!.id,
          exerciseName: workout.exerciseName,
          muscleGroup: workout.muscleGroup,
          sets: workout.sets,
          reps: workout.reps,
          weight: workout.weight,
          durationMinutes: workout.durationMinutes,
          workoutDate: workout.workoutDate,
        ),
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<WorkoutProvider>().errorMessage ??
                  'Terjadi kesalahan saat menyimpan workout.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label wajib diisi';
          }

          if (keyboardType != TextInputType.text) {
            final number = num.tryParse(value);
            if (number == null || number < 0) {
              return 'Masukkan angka yang valid';
            }
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        title: const Text('Add Workout'),
        backgroundColor: const Color(0xFFF5A9C8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Record Your Workout',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF30283D),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Keep track of your fitness progress!'),
              const SizedBox(height: 24),

              _buildTextField(
                label: 'Exercise Name',
                controller: _exerciseController,
              ),
              _buildTextField(
                label: 'Muscle Group',
                controller: _muscleController,
              ),
              _buildTextField(
                label: 'Sets',
                controller: _setsController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                label: 'Reps',
                controller: _repsController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                label: 'Weight (kg)',
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              _buildTextField(
                label: 'Duration (minutes)',
                controller: _durationController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 8),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                leading: const Icon(
                  Icons.calendar_month,
                  color: Color(0xFFA99BEF),
                ),
                title: const Text('Workout Date'),
                subtitle: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _selectDate,
              ),


              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A9C8),
                    foregroundColor: const Color(0xFF30283D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Save Workout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
