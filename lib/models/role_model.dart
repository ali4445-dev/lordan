import 'package:supabase_flutter/supabase_flutter.dart';

class Role {
  final String id;
  final String name;
  final String iconUrl;
  final bool isPremium;
  final bool isFeatured;

  const Role({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.isPremium,
    required this.isFeatured,
  });

  // Factory constructor to create Role from Supabase data
  factory Role.fromSupabase(Map<String, dynamic> data) {
    return Role(
      id: data['id'] as String,
      name: data['name'] as String,
      iconUrl: data['iconUrl'] as String,
      isPremium: data['isPremium'] as bool? ?? false,
      isFeatured: data['isFeatured'] as bool? ?? false,
    );
  }

  // Convert Role to JSON for local storage if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
      'isPremium': isPremium,
      'isFeatured': isFeatured,
    };
  }
}
