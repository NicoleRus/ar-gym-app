import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:
        'https://aojhsonruextcceqkhse.supabase.co', // replace with your actual Supabase project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFvamhzb25ydWV4dGNjZXFraHNlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQwNzI5NzMsImV4cCI6MjA1OTY0ODk3M30.yAqaZ1lLnhC_FZpH1gWXZkDCV8yUc3LsEScwREI5Cdo', // replace with your anon/public key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          Supabase.instance.client.auth.currentUser == null
              ? const AuthPage()
              : const NutritionLogScreen(),
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
      // TODO: Save the data to Supabase
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Entry saved!')));
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
