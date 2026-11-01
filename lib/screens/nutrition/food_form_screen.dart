import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/food_log.dart';
import '../../providers/nutrition_provider.dart';

class FoodFormScreen extends StatefulWidget {
  const FoodFormScreen({super.key});

  @override
  State<FoodFormScreen> createState() => _FoodFormScreenState();
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

  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _saveFood() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final foodLog = FoodLog(
      foodName: _foodNameController.text.trim(),
      calories: double.parse(_caloriesController.text),
      protein: double.parse(_proteinController.text),
      carbohydrates: double.parse(_carbsController.text),
      fat: double.parse(_fatController.text),
      mealType: _mealType,
      consumedAt: DateTime.now(),
    );

    try {
      final success = await context
          .read<NutritionProvider>()
          .addFoodLog(foodLog);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Makanan berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.read<NutritionProvider>().errorMessage ??
                  'Gagal menyimpan makanan.',
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

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bagian ini wajib diisi';
    }

    final number = double.tryParse(value);

    if (number == null || number < 0) {
      return 'Masukkan angka yang valid (minimal 0)';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        title: const Text('Add Food'),
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
              style: TextStyle(fontWeight: FontWeight.bold),
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

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5A9C8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  'Save Food',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isNumber,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          validator: isNumber
              ? _validateNumber
              : (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama makanan wajib diisi';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
