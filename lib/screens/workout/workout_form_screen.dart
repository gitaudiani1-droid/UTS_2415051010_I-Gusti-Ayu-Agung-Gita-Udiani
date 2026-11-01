import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/workout.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/custom_button.dart';

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
  final _formKey = GlobalKey<FormState>();

  final _exerciseController = TextEditingController();
  final _muscleController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _durationController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool _isSaving = false;

  bool get _isEditing => widget.workout != null;

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

    if (date != null && mounted) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  String? _validateText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }

    return null;
  }

  String? _validateInteger(
      String? value,
      String label,
      ) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }

    final number = int.tryParse(value);

    if (number == null || number <= 0) {
      return '$label harus berupa bilangan bulat lebih dari 0';
    }

    return null;
  }

  String? _validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Weight wajib diisi';
    }

    final number = double.tryParse(value);

    if (number == null || !number.isFinite || number < 0) {
      return 'Masukkan berat yang valid (minimal 0)';
    }

    return null;
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final workout = Workout(
      id: widget.workout?.id,
      exerciseName: _exerciseController.text.trim(),
      muscleGroup: _muscleController.text.trim(),
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
      weight: double.parse(_weightController.text),
      durationMinutes: int.parse(_durationController.text),
      workoutDate: selectedDate,
    );

    try {
      final provider = context.read<WorkoutProvider>();

      final success = _isEditing
          ? await provider.updateWorkout(workout)
          : await provider.addWorkout(workout);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Workout berhasil diperbarui!'
                  : 'Workout berhasil disimpan!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.errorMessage ??
                  'Terjadi kesalahan saat menyimpan workout.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan workout: $error'),
          backgroundColor: Colors.red,
        ),
      );
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
    required String? Function(String?) validator,
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
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Workout' : 'Add Workout',
        ),
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
              const Text(
                'Keep track of your fitness progress!',
              ),
              const SizedBox(height: 24),

              _buildTextField(
                label: 'Exercise Name',
                controller: _exerciseController,
                validator: (value) =>
                    _validateText(value, 'Exercise Name'),
              ),

              _buildTextField(
                label: 'Muscle Group',
                controller: _muscleController,
                validator: (value) =>
                    _validateText(value, 'Muscle Group'),
              ),

              _buildTextField(
                label: 'Sets',
                controller: _setsController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    _validateInteger(value, 'Sets'),
              ),

              _buildTextField(
                label: 'Reps',
                controller: _repsController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    _validateInteger(value, 'Reps'),
              ),

              _buildTextField(
                label: 'Weight (kg)',
                controller: _weightController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _validateWeight,
              ),

              _buildTextField(
                label: 'Duration (minutes)',
                controller: _durationController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    _validateInteger(value, 'Duration'),
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

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: _isEditing
                      ? 'Update Workout'
                      : 'Save Workout',
                  icon: Icons.save,
                  isLoading: _isSaving,
                  onPressed: _saveWorkout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
