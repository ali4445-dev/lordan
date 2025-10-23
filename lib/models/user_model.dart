import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class AppUser extends ChangeNotifier {
  final String userKey; // Unique ID (UUID v4)
  String status; // e.g. "free", "premium"
  DateTime createdAt;
  DateTime? expiresAt;
  DateTime updatedAt;
  String platform; // "android", "ios", "web"

  AppUser({
    String? userKey,
    required this.status,
    required this.createdAt,
    this.expiresAt,
    required this.updatedAt,
    required this.platform,
  }) : userKey = userKey ?? const Uuid().v4(); // ✅ Auto-generate UUID

  // --------------------------
  // 🔹 JSON serialization
  // --------------------------

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userKey: json['userKey'] ?? json['user_id'], // support both key names
      status: json['status'] ?? 'free',
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      updatedAt: DateTime.parse(json['updated_at']),
      platform: json['platform'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userKey': userKey,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'platform': platform,
    };
  }

  // --------------------------
  // 🔹 Update helper methods
  // --------------------------

  void updateStatus(String newStatus) {
    status = newStatus;
    updatedAt = DateTime.now();
    notifyListeners();
  }

  void updateExpiry(DateTime? newExpiry) {
    expiresAt = newExpiry;
    updatedAt = DateTime.now();
    notifyListeners();
  }

  void updatePlatform(String newPlatform) {
    platform = newPlatform;
    updatedAt = DateTime.now();
    notifyListeners();
  }

  void refreshFromJson(Map<String, dynamic> json) {
    if (json['status'] != null) status = json['status'];
    if (json['expires_at'] != null) {
      expiresAt = DateTime.tryParse(json['expires_at']);
    }
    if (json['updated_at'] != null) {
      updatedAt = DateTime.tryParse(json['updated_at']) ?? DateTime.now();
    }
    notifyListeners();
  }

  bool get isPremium => status.toLowerCase() == 'premium';

  bool get isTrialExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}
