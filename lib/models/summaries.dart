import 'package:hive/hive.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Summary {
  final String role;
  final DateTime time;
  final String content;

  Summary({
    required this.role,
    required this.time,
    required this.content,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      role: json['role']?.toString() ?? 'assistant',
      time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
      content: json['content']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'time': time.toIso8601String(),
        'content': content,
      };
}

class SummaryUtils {
  static final Box summariesBox = UserStorageService.getUserBox;

  static Future<List<Summary>> getSummaries() async {
    final String? email = Supabase.instance.client.auth.currentUser?.email;

    if (email == null || email.isEmpty) {
      print("⚠️ No logged-in email found — returning empty summaries list.");
      return [];
    }

    // 🔹 Load all user data from Hive
    final userData =
        Map<String, dynamic>.from(summariesBox.get(email, defaultValue: {}));

    final List<Summary> allSummaries = [];
    final now = DateTime.now();
    final updatedSummaries = <Map<String, dynamic>>[];

    // 🔹 Extract 'summaries' array (if exists)
    final summariesList = userData['summaries'];

    if (summariesList is List) {
      for (var item in summariesList) {
        if (item is Map) {
          try {
            final summary = Summary.fromJson(Map<String, dynamic>.from(item));

            // ✅ Only keep summaries newer than 24 hours
            final age = now.difference(summary.time).inHours;
            if (age < 24) {
              updatedSummaries.add(summary.toJson());
              allSummaries.add(summary);
            }
          } catch (e) {
            print("⚠️ Error converting summary: $e");
          }
        }
      }
    }

    // 🔹 Update Hive to remove old (>24h) summaries
    userData['summaries'] = updatedSummaries;
    summariesBox.put(email, userData);

    // 🔹 Sort summaries oldest → newest
    allSummaries.sort((a, b) => a.time.compareTo(b.time));

    return allSummaries;
  }
}
