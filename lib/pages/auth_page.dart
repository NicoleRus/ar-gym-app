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
  final _formKey = GlobalKey<FormState>();
  bool _isSignIn = true;
  bool _obscurePassword = true;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  void _toggleAuthMode() {
    setState(() {
      _isSignIn = !_isSignIn;
      _errorMessage = null;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _emailError =
            _emailController.text.isEmpty ? 'Email is required' : null;
        _passwordError =
            _passwordController.text.isEmpty ? 'Password is required' : null;
      });

      if (_emailError != null || _passwordError != null) return;

      setState(() => _isLoading = true);

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      try {
        if (_isSignIn) {
          await AuthService.signIn(email, password);
        } else {
          await AuthService.signUp(email, password);
        }
        setState(() => _isLoading = false);
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
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
                if (_errorMessage != null)
                  VSectionMessage(
                    hasClose: true,
                    hasTitle: true,
                    visible: true,
                    link: "Close",
                    sectionMessageState: SectionMessageState.error,
                    title: "Error",
                    description:
                        _errorMessage ??
                        _emailError ??
                        _passwordError ??
                        'An unknown error occurred.',
                  ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      VInput(
                        myLocalController: _emailController,
                        keyboardType: TextInputType.emailAddress,

                        topLabelText: 'Email',
                        //                         validator: (value) {
                        //   if (value == null || value.isEmpty) return 'Email required';
                        //   final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                        //   if (!emailRegex.hasMatch(value)) return 'Invalid email';
                        //   return null;
                        // },
                      ),
                      const SizedBox(height: 16),
                      VInput(
                        myLocalController: _passwordController,
                        topLabelText: 'Password',
                        hideText: _obscurePassword,
                        hintTextStyle: defaultVTheme.textStyles.uiLabelXSmall,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) return 'Password required';
                        //   if (value.length < 6) return 'Min 6 characters';
                        //   return null;
                        // },
                      ),
                      const SizedBox(height: 24),
                      VButton(
                        onPressed: _isLoading ? null : _submit,
                        child: Text(
                          _isLoading
                              ? 'Please wait...'
                              : (_isSignIn ? 'Sign In' : 'Sign Up'),
                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
