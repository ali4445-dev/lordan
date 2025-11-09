import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/models/message.dart';
import 'package:lordan_v1/models/user_model.dart';
import 'package:lordan_v1/providers/subscribtion_provider.dart';
import 'package:lordan_v1/service/chat_storage_service.dart';
import 'package:lordan_v1/service/supabase_service.dart';
import 'package:lordan_v1/service/trial_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../providers/user_provider.dart';

class UserStorageService with ChangeNotifier {
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
      final box = getUserBox;
      final data = box.get(email);

      if (data != null) {
        debugPrint("User Existing Session Restrored as :\n$data");
        loadUserData();
        return;
      }
    } else {
      print("SessionCannot be saved");
      return;
    }

    try {
      final now = DateTime.now();
      final expiryDate = now.add(const Duration(days: 1));

      // ✅ Generate a unique user ID
      final userId = const Uuid().v4();

      // ✅ Create user data map
      final userData = {
        "user_id": userId,
        "email": email,
        "status": "trial",
        "under_trial": true,
        "expires_at": expiryDate.toIso8601String(),
        "created_at": now.toIso8601String(),
        "updated_at": now.toIso8601String(),
        "summaries": [], // ✅ Initially empty list
      };

      // ✅ Save locally in Hive
      await getUserBox.put(email, userData);
      print("✅ User saved locally in Hive.");
      await loadUserData();
      // final user = AppUser(
      //     email: email ?? "No Email",
      //     // userKey: userId,
      //     status: "standard",
      //     createdAt: now,
      //     updatedAt: now,
      //     platform: Platform.isAndroid ? "android" : "ios");

      // GlobalData.setEmail(email ?? "Temparory User");

      // ✅ Save remotely in Supabase
      // final response = await supabase
      //     .from('entitlements')
      //     .insert(user.toJson()
      //         // empty initially
      //         )
      //     .select();

      // if (response.isNotEmpty) {
      //   print("✅ User saved remotely in Supabase. ${response}");
      // } else {
      //   print("⚠️ Supabase insert returned empty response.");
      // }
    } catch (e) {
      print("❌ Error creating user: $e");
    }

    chatBox.put(email, {});
  }

  /// Load user settings (if exist)
  static Future<bool> loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final userEmail = user.email;

      final data = _userBox.get(userEmail);

      if (data == null) return false;
      // final response = await supabase
      //     .from('entitlements')
      //     .select()
      //     .eq('email', userEmail)
      //     .maybeSingle();

      // if (response == null) {
      //   print("❌ No user found for $userEmail");
      //   return null;
      // }

      //  final userData = {
      //     "user_id": userId,
      //     "email": email,
      //     "plan": "standard",
      //     "under_trial": true,
      //     "trial_expiary": expiryDate.toIso8601String(),
      //     "created_at": now.toIso8601String(),
      //     "updated_at": now.toIso8601String(),
      //     "summaries": [], // ✅ Initially empty list
      //   };

      final appUser = AppUser.fromJson({
        'email': data['email'],
        'userKey': data['user_id'],
        'status': data['status'],
        'created_at': data['created_at'].toString(),
        'expires_at': data['expires_at'].toString(),
        'updated_at': data['updated_at'].toString(),
        'platform': data['platform'] ?? 'unknown',
      });

      GlobalData.setUser(appUser);
      print("App User Setted successfully ${GlobalData.user!.toJson()}");
      await TrialManager.loadTrialData();
      GlobalData.planInProgresss = data["plan"] ?? data["status"];

      return true;
    }
    return false;

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
    // await _userBox.clear();
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

  // static Future<void> migrateAndSaveRoles() async {
  //   final userBox = UserStorageService.getUserBox;

  //     final box = _userBox; // Or: final box = getUserBox;
  //     final existingData =
  //         Map<String, dynamic>.from(box.get(email, defaultValue: {}));

  //   // Get existing roles (list of strings or list of maps)
  //   final roles = userBox.get('roles', defaultValue: []);

  //   // If already in object format, skip migration
  //   if (roles.isNotEmpty && roles.first is Map) {
  //     return;
  //   }

  //   // Convert from list of strings → list of maps
  //   final newRoles = (roles as List).map((r) {
  //     return {
  //       "roleName": r,
  //       "isPremium": false, // default value
  //       "selectedAt": DateTime.now().toIso8601String(),
  //     };
  //   }).toList();

  //   // Save back into Hive
  //   await userBox.put('roles', newRoles);
  //   print(userBox.toMap());
  // }

  static Future<void> saveUserStatus(String productId,
      {bool cancel = false, PurchaseDetails? purchase}) async {
    DateTime now = DateTime.now();
    DateTime expiryDate = DateTime.now();

    final email = Supabase.instance.client.auth.currentUser?.email;
    if (email == null) {
      print("⚠️ No logged-in user found when saving status!");
      return;
    }

    final box = _userBox; // Or: final box = getUserBox;
    final existingData =
        Map<String, dynamic>.from(box.get(email, defaultValue: {}));

    if (purchase != null && purchase.transactionDate != null) {
      final expiryTime = DateTime.parse(existingData["expires_at"]);
      final updatedTime = DateTime.parse(existingData["updated_at"]);

      if (DateTime.now().isAfter(expiryTime)) {
        // Calculate plan duration
        final planDuration = expiryTime.difference(updatedTime);

        // Update expiry
        final updatedExpiry = expiryTime.add(planDuration);

        existingData["under_trial"] = false;
        existingData["updated_at"] = existingData["expires_at"];
        existingData["expires_at"] = updatedExpiry.toIso8601String();
      }

      print("Updated at ${existingData["updated_at"]}");
      print("Expires at ${existingData["expires_at"]}");

      // if (!purchase.productID.toLowerCase().contains("yearly")) {
      //   expiryDate = now.add(const Duration(days: 30));
      // } else if (purchase.productID.toLowerCase().contains("yearly")) {
      //   expiryDate = now.add(const Duration(days: 365));
      // }

      // if (purchase.status == PurchaseStatus.canceled) {
      //   existingData["plan"] =
      //       " ${purchase.productID.toUpperCase().replaceAll('.', ' ')}(canceled)";
      //   existingData["status"] =
      //       purchase.productID.toUpperCase().contains("PREMIUM")
      //           ? "premium"
      //           : "standard";
      // } else {
      //   print(purchase.productID.toUpperCase().contains("PREMIUM"));
      //   existingData["status"] =
      //       purchase.productID.toUpperCase().contains("PREMIUM")
      //           ? "premium"
      //           : "standard";
      //   existingData["plan"] =
      //       " ${purchase.productID.toUpperCase().replaceAll('.', ' ')}";
      // }

      // 🔹 Update user data locally in Hive

      await box.put(email, existingData);
      print("💾 Hive user updated: $existingData");

      loadUserData();
      return;

      // final purchase = SubscriptionService.checkSubscriptionStatus();
    } else {
      // 🔹 Determine expiry duration based on plan type
      if (!productId.toLowerCase().contains("yearly")) {
        expiryDate = now.add(const Duration(days: 30));
      } else if (productId.toLowerCase().contains("yearly")) {
        expiryDate = now.add(const Duration(days: 365));
      }

      final email = Supabase.instance.client.auth.currentUser?.email;
      if (email == null) {
        print("⚠️ No logged-in user found when saving status!");
        return;
      }

      if (cancel) {
        existingData["plan"] = "Unsubscribed";
        existingData["status"] = "free";
        await box.put(email, existingData);
        print("The user has cancelled the subscription");
        loadUserData();
        return;
      }

      // 🔹 Update user data locally in Hive
      existingData["status"] =
          productId.toUpperCase().contains("PREMIUM") ? "premium" : "standard";
      existingData["plan"] = productId.toUpperCase();

      existingData["under_trial"] = false;
      existingData["updated_at"] = now.toIso8601String();
      existingData["expires_at"] = expiryDate.toIso8601String();

      await box.put(email, existingData);
      print("💾 Hive user updated: $existingData");

      // 🔹 Sync with Supabase (optional but recommended)
      // try {
      //   await Supabase.instance.client.from('users').update({
      //     'status': productId,
      //     'expires_at': expiryDate.toIso8601String(),
      //     'updated_at': now.toIso8601String(),
      //   }).eq('email', email);
      //   print("✅ Supabase user status updated for $email");
      // } catch (e) {
      //   print("⚠️ Failed to update user status on Supabase: $e");
      // }

      // 🔹 Reload global user data (if your app caches it)
      await loadUserData();

      return;
    }
  }
}
