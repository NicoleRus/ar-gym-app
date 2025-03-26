import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NutritionLogScreen(),
    );
  }
}

class NutritionLogScreen extends StatefulWidget {
  const NutritionLogScreen({super.key});

  @override
  _NutritionLogScreenState createState() => _NutritionLogScreenState();
}

class _NutritionLogScreenState extends State<NutritionLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save the data somewhere (e.g., local storage, Supabase, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry saved!')),
      );
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Log')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_proteinController, 'Protein (g)'),
              _buildTextField(_carbsController, 'Carbs (g)'),
              _buildTextField(_fatsController, 'Fats (g)'),
              _buildTextField(_caloriesController, 'Total Calories'),
              _buildTextField(_weightController, 'Weight (lbs)'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
