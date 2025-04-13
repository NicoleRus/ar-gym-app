import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';

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
      title: 'AR Fitness and Nutrition',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const AuthPage(), // Start with Auth Screen
      routes: {
        '/home': (context) => const HomePage(),
        '/auth': (context) => const AuthPage(), // Add routes for other pages
      },
    );
  }
}
