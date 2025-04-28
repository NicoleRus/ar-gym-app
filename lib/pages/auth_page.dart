import 'package:ar_app/pages/sign_in_page.dart';
import 'package:ar_app/pages/sign_up_page.dart';
import 'package:flutter/material.dart'; // still needed for base layout
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import '../main_layout.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  bool _isSignIn = true;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;

  void _toggleAuthMode() {
    setState(() {
      _isSignIn = !_isSignIn;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      showHamburger: false,
      child: Center(
        child: VPanel(
          isFullScreen: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_errorMessage != null)
                VSectionMessage(
                  hasClose: true,
                  hasTitle: true,
                  visible: true,
                  link: "Close",
                  onClosePressed:
                      () => setState(() {
                        _errorMessage = null;
                      }),
                  sectionMessageState: SectionMessageState.error,
                  title: "Error",
                  description:
                      _errorMessage ??
                      _emailError ??
                      _passwordError ??
                      'An unknown error occurred.',
                ),
              const SizedBox(height: 24),
              _isSignIn
                  ? SignInPage()
                  : SignUpPage(), // Use the appropriate page based on the mode
              VLink(
                title:
                    _isSignIn
                        ? 'Create an account'
                        : 'Already have an account?',
                onPressed: _toggleAuthMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
