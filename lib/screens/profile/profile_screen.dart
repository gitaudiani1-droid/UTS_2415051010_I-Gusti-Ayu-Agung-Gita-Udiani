import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile berhasil diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFF4F8),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: Color(0xFFFFE1EC),
                  child: Icon(
                    Icons.person,
                    size: 55,
                    color: Color(0xFFF5A9C8),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Welcome to GLOWFIT!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF30283D),
                  ),
                ),
                const Text(
                  'Your fitness journey starts here.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

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

          const SizedBox(height: 28),

          const Text(
            'Daily Fitness Goals 🎯',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(18),
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
                const SizedBox(height: 12),
                Text(
                  '${_dailyCalories.toInt()} kcal',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF5A9C8),
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

          const SizedBox(height: 25),

          SizedBox(
            height: 52,
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
        TextField(
          controller: controller,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFFF5A9C8)),
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
