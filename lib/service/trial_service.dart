import 'package:hive/hive.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrialManager {
  static DateTime? expiryTime;

  static Future<void> loadTrialData() async {
    print("In trail Data");
    final box = UserStorageService.getUserBox;
    final email = Supabase.instance.client.auth.currentUser?.email;

    if (email == null) return;

    final data = box.get(email);
    print("Expiry time is ${data["expires_at"]}");
    if (data != null && data["expires_at"] != null) {
      expiryTime = DateTime.parse(data["expires_at"]);
      print(expiryTime);
    }
  }

  static bool get isTrialExpired {
    print(expiryTime);
    if (expiryTime == null) return true;

    return DateTime.now().isAfter(expiryTime!);
  }

  static Duration get timeLeft {
    if (expiryTime == null) return Duration.zero;
    return expiryTime!.difference(DateTime.now());
  }
}
