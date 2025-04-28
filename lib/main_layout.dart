import 'package:ar_app/widgets/menu_drawer.dart';
import 'package:ar_app/widgets/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';

class MainLayout extends StatelessWidget {
  final Widget child; // This is the content of the current page
  final bool showHamburger;

  const MainLayout({super.key, required this.child, this.showHamburger = true});

  @override
  Widget build(BuildContext context) {
    final user =
        Supabase
            .instance
            .client
            .auth
            .currentUser; // Get the current signed-in user

    return Scaffold(
      backgroundColor: VColors.defaultSurface1,
      appBar: VAppBarDefault(showHamburger: showHamburger),
      drawer: user != null ? NavDrawer() : null,
      body: Container(
        color: VColors.defaultSurface1,
        child: SingleChildScrollView(child: child),
      ), // This is where the child content (home page, auth page) gets inserted
    );
  }
}
