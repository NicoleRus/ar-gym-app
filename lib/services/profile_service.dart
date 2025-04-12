// lib/services/profile_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  static final _supabase = Supabase.instance.client;

  static Future<Map<String, dynamic>?> getProfile() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      final response =
          await _supabase.from('profiles').select().eq('id', user.id).single();
      if (response.error != null) {
        print(response.error!.message);
      } else {
        return response.data;
      }
    }
    return null;
  }

  static Future<void> updateProfile(String fullName) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      final response = await _supabase.from('profiles').upsert({
        'id': user.id,
        'full_name': fullName,
      });
      if (response.error != null) {
        print(response.error!.message);
      } else {
        print("Profile updated");
      }
    }
  }
}
