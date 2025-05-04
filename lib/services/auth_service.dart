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
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      final insertResult = await Supabase.instance.client
          .from('profiles')
          .insert({
            'id': response.user!.id,
            'email': email,
            'first_name': firstName,
            'last_name': lastName,
            'birth_date': birthDate,
          });

      if (insertResult == null) {
        // This should not happen—.single() will throw if nothing comes back
        print('Insert returned null!');
      } else {
        // Supabase Dart returns a Map with either `data` or `error`
        if (insertResult.error != null) {
          print('PROFILES INSERT ERROR: ${insertResult.error!.message}');
        } else {
          print('PROFILES INSERTED: ${insertResult.data}');
        }
      }
    } else {
      print(email);
      throw Exception('Sign up failed');
    }

    return response;
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
