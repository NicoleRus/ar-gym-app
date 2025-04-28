import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart'; // still needed for base layout
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import '../services/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_isLoading) return;
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();

      if (!EmailValidator.validate(email)) {
        setState(() {
          _errorMessage = 'Please enter a valid email address.';
        });
        return;
      }
      setState(() {
        _passwordError =
            _passwordController.text.isEmpty ? 'Password is required' : null;
      });

      if (_emailError != null || _passwordError != null) return;

      setState(() => _isLoading = true);

      final password = _passwordController.text;

      try {
        final response = await AuthService.signIn(email, password);

        if (response.user != null && mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        setState(() => _isLoading = false);
      } on AuthException catch (e) {
        setState(() {
          _errorMessage =
              e.message.contains('Invalid login credentials')
                  ? 'Invalid email or password. Please try again.'
                  : e.message; // already user-friendly!
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Something went wrong. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sign in',
          style: defaultVTheme.textStyles.subtitle1.copyWith(
            color: VColors.defaultActive,
            height: 1.2778,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back! Please sign in to continue.',
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
        Form(
          key: _formKey,
          child: Column(
            children: [
              VInput(
                myLocalController: _emailController,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => _submit(),
                topLabelText: 'Email',
              ),
              const SizedBox(height: 16),
              VInput(
                myLocalController: _passwordController,
                topLabelText: 'Password',
                hideText: _obscurePassword,
                hintTextStyle: defaultVTheme.textStyles.uiLabelXSmall,
                onSubmitted: (_) => _submit(),
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              VButton(
                onPressed: _submit,
                child: Text(_isLoading ? 'Please wait...' : 'Sign in'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
