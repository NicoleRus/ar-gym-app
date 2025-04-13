import 'package:flutter/material.dart'; // still needed for base layout
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import '../main_layout.dart';
import '../services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignIn = true;

  void _toggleAuthMode() {
    setState(() => _isSignIn = !_isSignIn);
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isSignIn) {
      await AuthService.signIn(email, password);
    } else {
      await AuthService.signUp(email, password);
    }

    // TODO: Add navigation or visual feedback
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        backgroundColor: VColors.defaultSurface1,
        body: Center(
          child: VPanel(
            isFullScreen: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isSignIn ? 'Sign In' : 'Sign Up',
                  style: defaultVTheme.textStyles.subtitle1.copyWith(
                    color: VColors.defaultActive,
                    height: 1.2778,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isSignIn
                      ? 'Welcome back! Please sign in to continue.'
                      : 'Create a new account to get started.',
                  style: defaultVTheme.textStyles.bodyText2Medium.copyWith(
                    color: VColors.defaultActive,
                    height: 1.2778,
                  ),
                ),
                const SizedBox(height: 24),
                VInput(
                  myLocalController: _emailController,
                  topLabelText: 'Email',
                ),
                const SizedBox(height: 16),
                VInput(
                  myLocalController: _passwordController,
                  topLabelText: 'Password',
                  hintTextStyle: defaultVTheme.textStyles.uiLabelXSmall,
                ),
                const SizedBox(height: 24),
                VButton(
                  onPressed: _submit,
                  child: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
                ),
                const SizedBox(height: 12),
                VLink(
                  title:
                      _isSignIn
                          ? 'Don’t have an account? Sign Up'
                          : 'Already have an account? Sign In',
                  onPressed: _toggleAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
