import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/models/summaries.dart';
import 'package:lordan_v1/providers/user_provider.dart';
import 'package:lordan_v1/screens/start/components/app_bar.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:lordan_v1/theme.dart';
import 'package:lordan_v1/utils/components/gradient_backdrop.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ✅ Your Summary model
// ✅ The SummaryUtils with getSummaries()

// ✅ GlobalData.plan assumed here

class ChatHistoryScreen extends StatefulWidget {
  static const String routeName = '/chat-history';

  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  late List<Summary> _summaries = [];

  @override
  void initState() {
    super.initState();
    _loadSummaries();
  }

  Future<void> _loadSummaries() async {
    try {
      final allSummaries = await SummaryUtils.getSummaries();
      setState(() {
        _summaries = allSummaries;
      });
    } catch (e) {
      print('❌ Error loading summaries: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    bool isDark = userProvider.themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    if (_summaries.isEmpty) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            GradientBackdrop(isDark: isDark),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildTopBar(theme, isPremiumUser: userProvider.isPremium),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No summaries found.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _summaries.length,
                    itemBuilder: (context, index) {
                      final summary = _summaries[index];
                      return _buildSummaryTile(summary);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🧩 Each summary card section
  Widget _buildSummaryTile(Summary summary) {
    final formattedTime = DateFormat('MMM dd, hh:mm a').format(summary.time);

    return Dismissible(
      key: Key(summary.time.toIso8601String()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.redAccent,
          size: 28,
        ),
      ),
      onDismissed: (direction) async {
        await _deleteSummary(summary);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.glassLight.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.only(top: 10),
          iconColor: Colors.white,
          title: Text(
            summary.role.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Text(
            formattedTime,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                summary.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.4,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            if (GlobalData.plan == "premium")
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    await _deleteSummary(summary);
                  },
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  label: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteSummary(Summary summary) async {
    final email = Supabase.instance.client.auth.currentUser?.email;
    if (email == null) return;

    final box = UserStorageService.getUserBox;
    final userData =
        Map<String, dynamic>.from(box.get(email, defaultValue: {}));

    final List summaries =
        (userData['summaries'] as List?)?.whereType<Map>().toList() ?? [];

    // remove matching summary
    summaries.removeWhere((item) =>
        item['content'] == summary.content &&
        item['time'] == summary.time.toIso8601String());

    userData['summaries'] = summaries;
    await box.put(email, userData);

    setState(() {
      _summaries.remove(summary);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Summary deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
