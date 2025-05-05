// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<AuthResponse> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Sign in failed');
    }
    return response;
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String birthDate,
  }) async {
    // trigger within Supabase adds user to 'profiles' table
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'birth_date': birthDate,
      },
    );

    // Check if the user was created successfully
    if (response.user == null) {
      throw Exception('Sign up failed: Unknown error');
    }

    return response;
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  static Future<void> resendConfirmationEmail(String email) async {
    await Supabase.instance.client.auth.resend(
      type: OtpType.signup, // for signup confirmation
      email: email, // the user’s email
    );
  }
}
