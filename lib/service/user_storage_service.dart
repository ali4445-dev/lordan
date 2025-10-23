import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/models/message.dart';
import 'package:lordan_v1/models/user_model.dart';
import 'package:lordan_v1/service/chat_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../providers/user_provider.dart';

class UserStorageService extends ChangeNotifier {
  static final Box _userBox = Hive.box('userBox');
  static Box get getUserBox => _userBox;

  /// Save all user settings for a given email
  static final supabase = Supabase.instance.client;

  static Future<void> createUserRecord() async {
    final currentUser = supabase.auth.currentUser;
    final chatBox = ChatStorageService.chatBox;
    String? email;
    if (currentUser != null) {
      email = currentUser.email;
    } else {
      print("SessionCannot be saved");
      return;
    }

    ;
    try {
      final now = DateTime.now();
      final expiryDate = now.add(const Duration(days: 7));

      // ✅ Generate a unique user ID
      final userId = const Uuid().v4();

      // ✅ Create user data map
      final userData = {
        "user_id": userId,
        "email": email,
        "plan": "standard",
        "under_trial": true,
        "trial_expiary": expiryDate.toIso8601String(),
        "created_at": now.toIso8601String(),
        "updated_at": now.toIso8601String(),
        "summaries": [], // ✅ Initially empty list
      };

      // ✅ Save locally in Hive
      await getUserBox.put(email, userData);
      print("✅ User saved locally in Hive.");

      final user = AppUser(
          userKey: userId,
          status: "standard",
          createdAt: now,
          updatedAt: now,
          platform: Platform.isAndroid ? "android" : "ios");

      // ✅ Save remotely in Supabase
      final response = await supabase.from('users').insert({
        user.toJson()
        // empty initially
      }).select();

      if (response.isNotEmpty) {
        print("✅ User saved remotely in Supabase. ${response}");
      } else {
        print("⚠️ Supabase insert returned empty response.");
      }
    } catch (e) {
      print("❌ Error creating user: $e");
    }

    chatBox.put(email, {});
  }

  /// Load user settings (if exist)
  static Future<void> loadUserData() async {
    final user = await Supabase.instance.client.auth.currentUser;

    late final userEmail;
    if (user != null) {
      userEmail = await user.email;
    }

    final data = _userBox.get(userEmail);

    if (data == null) return;
    final response = await supabase
        .from('users')
        .select()
        .eq('email', userEmail)
        .maybeSingle();

    if (response == null) {
      print("❌ No user found for $userEmail");
      return null;
    }

    final appUser = AppUser.fromJson({
      'userKey': response['userKey'],
      'status': response['status'],
      'created_at': response['created_at'],
      'expires_at': response['expires_at'],
      'updated_at': response['updated_at'],
      'platform': response['platform'] ?? 'unknown',
    });

    GlobalData.setUser(appUser);

    // Restore locale

    // Restore roles
    // if (data['roles'] != null) {
    //  GlobalData.selectedRoles = List<String>.from(data['roles']) as Set;
    // }

    // // Restore theme
    // if (data['theme'] != null) {
    //   user.setThemeFromString(data['theme']);
    // }

    // // Restore premium
    // user.isPremium = data['isPremium'] ?? false;
  }

  /// Debug: view all stored data
  static void printAll() {
    print(_userBox.toMap());
  }

  /// Clear all data for a specific user
  static Future<void> clear() async {
    await _userBox.clear();
    print("User box is ${_userBox.toMap()}");
  }

  // Future<void> clearUserSession() async {
  //   final sessionBox = await Hive.openBox('user_box');
  //   await sessionBox.clear();
  // }

  static List<String> getSavedRoles() {
    final userBox = Hive.box('userBox');
    final roles = userBox.get('roles', defaultValue: <String>[]);
    return List<String>.from(roles);
  }

  static Future<void> migrateAndSaveRoles() async {
    final userBox = UserStorageService.getUserBox;

    // Get existing roles (list of strings or list of maps)
    final roles = userBox.get('roles', defaultValue: []);

    // If already in object format, skip migration
    if (roles.isNotEmpty && roles.first is Map) {
      return;
    }

    // Convert from list of strings → list of maps
    final newRoles = (roles as List).map((r) {
      return {
        "roleName": r,
        "isPremium": false, // default value
        "selectedAt": DateTime.now().toIso8601String(),
      };
    }).toList();

    // Save back into Hive
    await userBox.put('roles', newRoles);
    print(userBox.toMap());
  }

  static void saveUserStatus() async {
    final now = DateTime.now();
    final expiryDate = now.add(const Duration(days: 30));
    final email = supabase.auth.currentUser!.email;

    await _userBox.put("status", "premium");
    await _userBox.put("updated_at", now.toIso8601String());
    await _userBox.put("expiare_at", expiryDate.toIso8601String());

    await Supabase.instance.client.from('users').update({
      'status': 'premium',
      'expires_at': expiryDate.toIso8601String(),
      'updated_at': now.toIso8601String(),
    }).eq('email', email!);
  }
}
