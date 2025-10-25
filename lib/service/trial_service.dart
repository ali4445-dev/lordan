import 'package:hive/hive.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrialManager {
  static DateTime? expiryTime;

  static Future<void> loadTrialData() async {
    final box = UserStorageService.getUserBox;
    final email = Supabase.instance.client.auth.currentUser?.email;

    if (email == null) return;

    final data = box.get(email);
    print("Expiry time is ${data["trial_expiary"]}");
    if (data != null && data["trial_expiary"] != null) {
      expiryTime = DateTime.parse(data["trial_expiary"]);
    }
  }

  static bool get isTrialExpired {
    if (expiryTime == null) return true;

    return DateTime.now().isAfter(expiryTime!);
  }

  static Duration get timeLeft {
    if (expiryTime == null) return Duration.zero;
    return expiryTime!.difference(DateTime.now());
  }
}
