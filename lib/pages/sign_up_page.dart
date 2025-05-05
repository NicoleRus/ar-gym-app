import 'package:ar_app/pages/confirm_email.dart';
import 'package:ar_app/widgets/birth_date.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visa_nova_flutter/visa_nova_flutter.dart';

import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, String?> _errors = {};

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    for (final field in [
      'firstName',
      'lastName',
      'birthDate',
      'email',
      'password',
      'confirmPassword',
    ]) {
      _focusNodes[field] = FocusNode();
      _errors[field] = null;

      _focusNodes[field]!.addListener(() {
        if (!_focusNodes[field]!.hasFocus) {
          _validateField(field);
        }
      });
    }
  }

  void _validateField(String field) {
    final value = _getFieldValue(field);

    switch (field) {
      case 'firstName':
      case 'lastName':
        if (value.isEmpty || !RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
          _setError(
            field,
            'Invalid ${field == 'firstName' ? 'First' : 'Last'} Name',
          );
        } else {
          _setError(field, null);
        }
        break;

      case 'birthDate':
        try {
          final parts = value.split('-');
          DateTime? date;
          if (value.length == 3) {
            final month = int.parse(parts[0]);
            final day = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            date = DateTime(year, month, day);
          }
          if (date != null && date.isAfter(DateTime.now())) {
            _setError(field, 'Birth date cannot be in the future.');
          } else {
            _setError(field, null);
          }
        } catch (e) {
          _setError(field, 'Invalid birth date.');
        }
        break;

      case 'email':
        if (!EmailValidator.validate(value)) {
          _setError(field, 'Invalid email.');
        } else {
          _setError(field, null);
        }
        break;

      case 'password':
        if (value.isEmpty || value.length < 6) {
          _setError(field, 'Password must be at least 6 characters.');
        } else {
          _setError(field, null);
        }
        break;

      case 'confirmPassword':
        if (value != _passwordController.text) {
          _setError(field, 'Passwords do not match.');
        } else {
          _setError(field, null);
        }
        break;
    }
  }

  Future<void> _submit() async {
    if (_isLoading) return;

    setState(() {
      _errors.clear();
      _errorMessage = null;
    });

    for (final field in _focusNodes.keys) {
      _validateField(field);
    }

    final hasErrors = _errors.values.any((error) => error != null);
    if (hasErrors) {
      _scrollToFirstError();
      return;
    }

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final birthDate = _birthDateController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
      );

      if (!mounted) return;

      if (response.user != null) {
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ConfirmEmailPage(email: _emailController.text),
            ),
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Something went wrong. Please try again.';
          _isLoading = false;
        });
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message; // already user-friendly!
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _setError(String field, String? error) {
    setState(() {
      _errors[field] = error;
    });
  }

  String _getFieldValue(String field) {
    switch (field) {
      case 'firstName':
        return _firstNameController.text.trim();
      case 'lastName':
        return _lastNameController.text.trim();
      case 'birthDate':
        return _birthDateController.text.trim();
      case 'email':
        return _emailController.text.trim();
      case 'password':
        return _passwordController.text;
      case 'confirmPassword':
        return _confirmPasswordController.text;
      default:
        return '';
    }
  }

  void _scrollToFirstError() {
    final firstInvalid = _errors.entries.firstWhere(
      (entry) => entry.value != null,
      orElse: () => const MapEntry('', null),
    );

    if (firstInvalid.key.isNotEmpty) {
      final focusNode = _focusNodes[firstInvalid.key];
      focusNode?.requestFocus();
    }
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
            onClosePressed: () => setState(() => _errorMessage = null),
            sectionMessageState: SectionMessageState.error,
            title: "Error",
            description: _errorMessage!,
          ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            children: [
              VInput(
                myLocalController: _firstNameController,
                inputFocusNode: _focusNodes['firstName'],
                topLabelText: 'First Name',
                errorText: _errors['firstName'] ?? '',
                hasError: _errors['firstName'] != null,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              VInput(
                myLocalController: _lastNameController,
                inputFocusNode: _focusNodes['lastName'],
                topLabelText: 'Last Name',
                errorText: _errors['lastName'] ?? '',
                hasError: _errors['lastName'] != null,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              BirthDateField(
                controller: _birthDateController,
                focusNode: _focusNodes['birthDate']!,
                hasError: _errors['birthDate'] != null,
                errorText: _errors['birthDate'],
                onChanged: (_) => _validateField('birthDate'),
              ),
              const SizedBox(height: 16),
              VInput(
                myLocalController: _emailController,
                inputFocusNode: _focusNodes['email'],
                topLabelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                errorText: _errors['email'] ?? '',
                hasError: _errors['email'] != null,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              VInput(
                myLocalController: _passwordController,
                inputFocusNode: _focusNodes['password'],
                topLabelText: 'Password',
                hideText: _obscurePassword,
                errorText: _errors['password'] ?? '',
                hasError: _errors['password'] != null,
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
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              VInput(
                myLocalController: _confirmPasswordController,
                inputFocusNode: _focusNodes['confirmPassword'],
                topLabelText: 'Confirm Password',
                hideText: _obscurePassword,
                errorText: _errors['confirmPassword'] ?? '',
                hasError: _errors['confirmPassword'] != null,
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
