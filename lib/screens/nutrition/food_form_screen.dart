import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/food_log.dart';
import '../../providers/nutrition_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class FoodFormScreen extends StatefulWidget {
  final FoodLog? food;

  const FoodFormScreen({
    super.key,
    this.food,
  });

  @override
  State<FoodFormScreen> createState() =>
      _FoodFormScreenState();
}

class _FoodFormScreenState extends State<FoodFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  String _mealType = 'Breakfast';
  bool _isSaving = false;

  bool get _isEditing => widget.food != null;

  @override
  void initState() {
    super.initState();

    final food = widget.food;

    if (food != null) {
      _foodNameController.text = food.foodName;
      _caloriesController.text = food.calories.toString();
      _proteinController.text = food.protein.toString();
      _carbsController.text = food.carbohydrates.toString();
      _fatController.text = food.fat.toString();
      _mealType = food.mealType;
    }
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }

    final number = double.tryParse(value);

    if (number == null || !number.isFinite || number < 0) {
      return 'Masukkan angka yang valid (minimal 0)';
    }

    return null;
  }

  String? _validateFoodName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama makanan wajib diisi';
    }

    return null;
  }

  Future<void> _saveFood() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final foodLog = FoodLog(
      id: widget.food?.id,
      foodName: _foodNameController.text.trim(),
      calories: double.parse(_caloriesController.text),
      protein: double.parse(_proteinController.text),
      carbohydrates: double.parse(_carbsController.text),
      fat: double.parse(_fatController.text),
      mealType: _mealType,
      consumedAt: widget.food?.consumedAt ?? DateTime.now(),
    );

    try {
      final provider = context.read<NutritionProvider>();

      final success = _isEditing
          ? await provider.updateFoodLog(foodLog)
          : await provider.addFoodLog(foodLog);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Makanan berhasil diperbarui!'
                  : 'Makanan berhasil disimpan!',
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
                  'Gagal menyimpan makanan.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $error'),
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
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isNumber,
  }) {
    return CustomTextField(
      label: label,
      hintText: hint,
      controller: controller,
      icon: isNumber ? Icons.numbers : Icons.restaurant,
      isNumber: isNumber,
      validator: isNumber
          ? _validateNumber
          : _validateFoodName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Food' : 'Add Food'),
        backgroundColor: const Color(0xFFFFF4F8),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'What did you eat today? 🍓',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30283D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Catat makanan dan kandungan nutrisinya.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            _buildTextField(
              controller: _foodNameController,
              label: 'Food Name',
              hint: 'Contoh: Nasi Goreng',
              isNumber: false,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _caloriesController,
              label: 'Calories (kcal)',
              hint: 'Contoh: 250',
              isNumber: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _proteinController,
              label: 'Protein (g)',
              hint: 'Contoh: 12',
              isNumber: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _carbsController,
              label: 'Carbohydrates (g)',
              hint: 'Contoh: 35',
              isNumber: true,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _fatController,
              label: 'Fat (g)',
              hint: 'Contoh: 8',
              isNumber: true,
            ),
            const SizedBox(height: 16),

            const Text(
              'Meal Type',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF30283D),
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: _mealType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Breakfast',
                  child: Text('Breakfast'),
                ),
                DropdownMenuItem(
                  value: 'Lunch',
                  child: Text('Lunch'),
                ),
                DropdownMenuItem(
                  value: 'Dinner',
                  child: Text('Dinner'),
                ),
                DropdownMenuItem(
                  value: 'Snack',
                  child: Text('Snack'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _mealType = value;
                  });
                }
              },
            ),

            const SizedBox(height: 28),

            CustomButton(
              text: _isEditing ? 'Update Food' : 'Save Food',
              icon: Icons.save,
              isLoading: _isSaving,
              onPressed: _saveFood,
            ),
          ],
        ),
      ),
    );
  }
}
