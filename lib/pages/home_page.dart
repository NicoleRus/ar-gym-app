import 'package:ar_app/main_layout.dart';
import 'package:ar_app/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import 'package:visa_nova_icons_flutter/visa_nova_icons_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // 🛠️ This line fixes the issue
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
