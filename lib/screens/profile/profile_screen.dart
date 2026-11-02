import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/nutrition_goal.dart';
import '../../providers/nutrition_goal_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'GITAYU');
  final _weightController = TextEditingController(text: '55');
  final _heightController = TextEditingController(text: '160');

  double _dailyCalories = 2000;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<NutritionGoalProvider>().loadNutritionGoal();

      if (!mounted) return;

      final goal = context.read<NutritionGoalProvider>().goal;

      if (goal != null) {
        setState(() {
          _dailyCalories = goal.dailyCalories
              .clamp(1000.0, 4000.0)
              .toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<NutritionGoalProvider>();

    final goal = NutritionGoal(
      id: provider.goal?.id,
      dailyCalories: _dailyCalories,
      proteinGoal: provider.goal?.proteinGoal ?? 100,
      carbsGoal: provider.goal?.carbsGoal ?? 250,
      fatGoal: provider.goal?.fatGoal ?? 65,
    );

    final success = await provider.saveNutritionGoal(goal);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Profile dan target berhasil diperbarui!'
              : provider.errorMessage ?? 'Gagal menyimpan target.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        toolbarHeight:
        MediaQuery.of(context).orientation == Orientation.landscape
            ? 44
            : 56,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFF4F8),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape =
              MediaQuery.of(context).orientation ==
                  Orientation.landscape;
          final isWide = constraints.maxWidth >= 700;
          final compact = isLandscape || isWide;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(compact ? 12 : 20),
                child: compact
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildProfileHeader(compact),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: _buildProfileForm(compact),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    _buildProfileHeader(compact),
                    const SizedBox(height: 25),
                    _buildProfileForm(compact),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(bool compact) {
    return Column(
      children: [
        CircleAvatar(
          radius: compact ? 34 : 48,
          backgroundColor: const Color(0xFFFFE1EC),
          child: Icon(
            Icons.person,
            size: compact ? 40 : 55,
            color: const Color(0xFFF5A9C8),
          ),
        ),
        SizedBox(height: compact ? 8 : 12),
        Text(
          'Welcome to GLOWFIT!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: compact ? 17 : 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF30283D),
          ),
        ),
        const Text(
          'Your fitness journey starts here.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProfileForm(bool compact) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildField(
            label: 'Name',
            controller: _nameController,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  label: 'Weight (kg)',
                  controller: _weightController,
                  icon: Icons.monitor_weight_outlined,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildField(
                  label: 'Height (cm)',
                  controller: _heightController,
                  icon: Icons.height,
                  isNumber: true,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 18 : 28),
          const Text(
            'Daily Fitness Goals 🎯',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(compact ? 14 : 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Calories Target',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_dailyCalories.toInt()} kcal',
                  style: TextStyle(
                    fontSize: compact ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF5A9C8),
                  ),
                ),
                Slider(
                  value: _dailyCalories,
                  min: 1000,
                  max: 4000,
                  divisions: 30,
                  activeColor: const Color(0xFFF5A9C8),
                  onChanged: (value) {
                    setState(() {
                      _dailyCalories = value;
                    });
                  },
                ),
                const Text(
                  'Atur target kalori harianmu.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: compact ? 46 : 52,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5A9C8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Save Profile & Goals',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isNumber = false,
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
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label wajib diisi.';
            }

            if (isNumber) {
              final number = double.tryParse(value);

              if (number == null || number <= 0) {
                return 'Masukkan angka yang valid.';
              }
            }

            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color(0xFFF5A9C8),
            ),
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
