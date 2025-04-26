import 'package:ar_app/main_layout.dart';
import 'package:ar_app/widgets/dashboard_cart.dart';
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
        child: Column(
          children: [
            const Text(
              'Welcome back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Here’s what you can do today:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2, // 2 cards per row
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              // padding: const EdgeInsets.all(16),
              // childAspectRatio: 1.2, // Adjust as needed for your card shape
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DashboardCard(
                  title: "View workouts",
                  subtitle: "Downloads & Guides",
                  description: "Access your resources",
                  icon: VIcons.helpHigh,
                  onTap: () {
                    // Navigate to resources
                  },
                ),
                DashboardCard(
                  title: "Log nutrition",
                  subtitle: "Downloads & Guides",
                  description: "Access your resources",
                  icon: VIcons.helpHigh,
                  onTap: () {
                    // Navigate to resources
                  },
                ),
                DashboardCard(
                  icon: VIcons.dashboardHigh,
                  title: 'Track Progress',
                  onTap: () {
                    // Navigate to tracking page
                  },
                ),
                DashboardCard(
                  icon: VIcons.documentHigh,
                  title: 'Access Resources',
                  onTap: () {
                    // Navigate to resources page
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
