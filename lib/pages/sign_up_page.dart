import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart'; // still needed for base layout
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';
import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final name = _nameController.text.trim();
    final birthDate = _birthDateController.text.trim();

    if (!EmailValidator.validate(email)) {
      return _setError('Please enter a valid email address.');
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      return _setError('Password fields cannot be empty.');
    }

    if (password != confirmPassword) {
      return _setError('Passwords do not match.');
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.signUp(
        email: email,
        password: password,
        name: name,
        birthDate: birthDate,
      );

      if (!mounted) return;

      if (response.user != null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        _setError('Something went wrong. Please try again.');
      }
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Something went wrong. Please try again.');
    }
  }

  void _setError(String message) {
    if (!mounted) return;
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sign Up',
          style: defaultVTheme.textStyles.subtitle1.copyWith(
            color: VColors.defaultActive,
            height: 1.2778,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create a new account to get started.',
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
                myLocalController: _nameController,
                topLabelText: 'Full Name',
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              VInput(
                myLocalController: _birthDateController,
                topLabelText: 'Birth Date',
                onSubmitted: (_) {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime(2000, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      _birthDateController.text =
                          pickedDate.toLocal().toString().split(' ')[0];
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              VInput(
                myLocalController: _confirmPasswordController,
                topLabelText: 'Confirm Password',
                hideText: _obscurePassword,
                hintTextStyle: defaultVTheme.textStyles.uiLabelXSmall,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              VButton(
                onPressed: _submit,
                child: Text(_isLoading ? 'Please wait...' : 'Sign Up'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
