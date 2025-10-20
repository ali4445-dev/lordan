import 'package:lordan_v1/global.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile {
  final String fullName;
  final String? avatarUrl;
  final String plan;

  const UserProfile({
    required this.fullName,
    this.avatarUrl,
    required this.plan,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['full_name'] ?? 'User',
      avatarUrl: json['avatar_url'],
      plan: json['plan'] ?? 'free',
    );
  }
}

class Role {
  final String id;
  final String name;
  final String description;
  final bool isPremium;
  final bool isFeatured;

  const Role({
    required this.id,
    required this.name,
    required this.description,
    required this.isPremium,
    required this.isFeatured,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isPremium: json['is_premium'] ?? false,
      isFeatured: json['featured'] ?? false,
    );
  }
}

// Models for new database operations
class DailyStats {
  final DateTime statDate;
  final int freeUsers;
  final int premiumUsers;
  final int newSignups;

  const DailyStats({
    required this.statDate,
    required this.freeUsers,
    required this.premiumUsers,
    required this.newSignups,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      statDate: DateTime.parse(json['stat_date']),
      freeUsers: json['free_users'] ?? 0,
      premiumUsers: json['premium_users'] ?? 0,
      newSignups: json['new_signups'] ?? 0,
    );
  }
}

class Subscription {
  final String userId;
  final String email;
  final String plan;
  final String store;
  final DateTime startedAt;
  final DateTime expiresAt;
  final bool active;

  const Subscription({
    required this.userId,
    required this.email,
    required this.plan,
    required this.store,
    required this.startedAt,
    required this.expiresAt,
    required this.active,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      userId: json['user_id'],
      email: json['email'],
      plan: json['plan'],
      store: json['store'],
      startedAt: DateTime.parse(json['started_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      active: json['active'] ?? false,
    );
  }
}

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService() : _client = Supabase.instance.client;

  // Get current user's profile
  Future<UserProfile> fetchUserProfile() async {
    if (_client.auth.currentUser == null) throw Exception('Not authenticated');

    // final response = await _client.from('profiles').select().eq('id', _client.auth.currentUser!.id).single();

    return UserProfile(fullName: GlobalData.email ?? "Guest User", plan: GlobalData.plan);
  }

  // Fetch roles based on filter and search query
  Future<List<Role>> fetchRoles({
    String? searchQuery,
    String filter = 'All',
  }) async {
    var query = _client.from('roles').select();

    // Apply filter
    switch (filter) {
      case 'Free':
        query = query.eq('is_premium', false);
        break;
      case 'Premium':
        query = query.eq('is_premium', true);
        break;
      case 'My Roles':
        if (_client.auth.currentUser == null) throw Exception('Not authenticated');
        query = query.eq('user_id', _client.auth.currentUser!.id);
        break;
    }

    // Apply search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }

    final response = await query;
    return (response as List).map((json) => Role.fromJson(json)).toList();
  }

  // Fetch featured roles
  Future<List<Role>> fetchFeaturedRoles() async {
    final response = await _client.from('roles').select().eq('featured', true);

    print("Fetch Featured Roles ${response.map((json) => Role.fromJson(json)).toList()}");
    return (response as List).map((json) => Role.fromJson(json)).toList();
  }

  /// Fetches daily statistics for a date range
  /// Used in: AdminDashboardScreen to show usage trends
  Future<List<DailyStats>> fetchDailyStats(DateTime from, DateTime to) async {
    final response = await _client.from('daily_stats').select().gte('stat_date', from.toIso8601String()).lte('stat_date', to.toIso8601String()).order('stat_date');

    return (response as List).map((json) => DailyStats.fromJson(json)).toList();
  }

  /// Records when a user uses a role
  /// Used in: ConversationScreen when starting a chat
  Future<void> insertRoleUsage({
    required String userId,
    required String roleName,
  }) async {
    await _client.from('role_usage').insert({
      'user_id': userId,
      'role_name': roleName,
      'used_at': DateTime.now().toIso8601String(),
    });
  }

  /// Lists all active subscriptions with user emails
  /// Used in: AdminSubscriptionsScreen
  Future<List<Subscription>> listActiveSubscriptionsWithUserEmail() async {
    final response = await _client.from('subscriptions').select('''
          *,
          users (
            email
          )
        ''').eq('active', true);

    return (response as List)
        .map((json) => Subscription.fromJson({
              ...json,
              'email': json['users']['email'],
            }))
        .toList();
  }

  /// Checks if an email is whitelisted
  /// Used in: AuthScreen during signup
  Future<bool> isEmailWhitelisted(String email) async {
    final response = await _client.from('whitelist').select().eq('email', email).maybeSingle();

    return response != null;
  }

  /// Counts new signups in the last 7 days
  /// Used in: AdminDashboardScreen stats widget
  Future<int> countNewSignupsLast7Days() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    final data = await _client.from('users').select('id').gte('created_at', sevenDaysAgo.toIso8601String());

    return (data as List).length;
  }
}

// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/role_model.dart';
//
// class SupabaseService {
//   static final SupabaseClient _client = Supabase.instance.client;
//
//   // Fetch all roles from Supabase
//   static Future<List<Role>> fetchRoles() async {
//     try {
//       final response = await _client
//           .from('roles')
//           .select('id, name, iconUrl, isPremium, isFeatured')
//           .order('name');
//
//       final List<dynamic> data = response as List<dynamic>;
//       return data.map((roleData) => Role.fromSupabase(roleData)).toList();
//     } catch (e) {
//       // Return empty list if there's an error (e.g., table doesn't exist yet)
//       return [];
//     }
//   }
//
//   // Fetch featured roles only
//   static Future<List<Role>> fetchFeaturedRoles() async {
//     try {
//       final response = await _client
//           .from('roles')
//           .select('id, name, iconUrl, isPremium, isFeatured')
//           .eq('isFeatured', true)
//           .order('name');
//
//       final List<dynamic> data = response as List<dynamic>;
//       return data.map((roleData) => Role.fromSupabase(roleData)).toList();
//     } catch (e) {
//       return [];
//     }
//   }
//
//   // Get current user information
//   static Future<Map<String, dynamic>?> getCurrentUser() async {
//     try {
//       final user = _client.auth.currentUser;
//       if (user == null) return null;
//
//       return {
//         'id': user.id,
//         'email': user.email,
//         'username': user.userMetadata?['username'] ?? user.email?.split('@')[0] ?? 'User',
//         'avatarUrl': user.userMetadata?['avatar_url'],
//         'isPremium': user.userMetadata?['isPremium'] ?? false,
//       };
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Check if current user is premium
//   static Future<bool> isCurrentUserPremium() async {
//     final user = await getCurrentUser();
//     return user?['isPremium'] ?? false;
//   }
// }
