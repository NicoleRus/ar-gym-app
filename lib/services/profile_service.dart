import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgrest/postgrest.dart'; // for PostgrestResponse

class Profile {
  final String id;
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final String? phone;
  final String? address;
  final DateTime createdAt;
  final String email;

  Profile({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.phone,
    this.address,
    required this.createdAt,
  });

  factory Profile.fromMap(Map<String, dynamic> m) => Profile(
    id: m['id'] as String,
    email: m['email'] as String,
    firstName: m['first_name'] as String?,
    lastName: m['last_name'] as String?,
    phone: m['phone'] as String?,
    address: m['address'] as String?,
    birthDate: m['birth_date'] != null ? DateTime.parse(m['birth_date']) : null,
    createdAt: DateTime.parse(m['created_at'] as String),
  );
}

class ProfileService {
  static final _client = Supabase.instance.client;

  /// Fetch the current user’s profile
  static Future<Profile> fetchProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Not signed in');
    }

    final res =
        await Supabase.instance.client
            .from('profiles')
            .select<Map<String, dynamic>>(
              'id, email, first_name, last_name, birth_date, phone, address, created_at',
            )
            .eq('id', user.id)
            .single(); // or .maybeSingle()

    // if (res.error != null) {
    //   throw Exception('Failed to update profile: ${res.error!.message}');
    // }
    return Profile.fromMap(res);
  }

  /// Update the current user’s editable fields
  static Future<Profile> updateProfile({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? phone,
    String? address,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Not signed in');
    }

    final payload = <String, dynamic>{
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (birthDate != null)
        'birth_date': birthDate.toIso8601String().split('T').first,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    };

    final res =
        await _client
            .from('profiles')
            .update(payload)
            .eq('id', user.id)
            .select<Map<String, dynamic>>(
              'id, email, first_name, last_name, birth_date, phone, address, created_at',
            )
            .single();

    // if (res.error != null) {
    //   throw Exception('Failed to update profile: ${res.error!.message}');
    // }
    return Profile.fromMap(res);
  }
}
