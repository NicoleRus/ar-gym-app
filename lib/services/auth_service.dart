// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<void> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    print(email);
    print(password);
    print(response);
    print(response.user);

    if (response.user == null) {
      throw Exception('Sign in failed');
    }
  }

  static Future<void> signUp(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Sign up failed');
    }
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
