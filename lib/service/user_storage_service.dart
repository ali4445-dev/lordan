import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/models/message.dart';
import 'package:lordan_v1/service/chat_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/user_provider.dart';

class UserStorageService {
  static final Box _userBox = Hive.box('userBox');
  static Box get getUserBox => _userBox;

  /// Save all user settings for a given email
  static Future<void> saveUserData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    final user = await Supabase.instance.client.auth.currentUser;
    late final userEmail;
    if (user != null) {
      userEmail = await user.email;
    }
    final roleNames = GlobalData.selectedRoles.map((r) => r.name).toList();
    print(GlobalData.language);
    print(roleNames);
    print(GlobalData.plan);
    final userData = {
      'locale': GlobalData.language,
      'roles': roleNames,
      // 'theme': user.themeMode.toString(),
      'plan': GlobalData.plan,
    };

    final chatBox = ChatStorageService.chatBox;
    // ✅ Create initial chat data structure
    final Map<String, dynamic> chatData = {
      for (final role in roleNames) role: <Map<String, dynamic>>[],
    };
    await _userBox.put(userEmail, userData);

    print("USer Box Created");

    // ✅ Save this user's chat record
    await chatBox.put(userEmail, chatData);

    debugPrint(
        '📦 Created user + initialized chatBox for $userEmail as ${_userBox.toMap()} and  ${chatBox.toMap()}');
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

    // Restore locale
    final langCode = data['locale'];
    if (langCode != null) {
      GlobalData.language = langCode;
    }

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
}
