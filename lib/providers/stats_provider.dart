import 'package:flutter/foundation.dart';
import '../service/supabase_service.dart';

class StatsProvider with ChangeNotifier {
  final SupabaseService _supabase;

  StatsProvider(this._supabase);

  bool _loading = false;
  List<DailyStats> _stats = [];
  int _newSignups = 0;
  String? _error;

  bool get loading => _loading;

  List<DailyStats> get stats => _stats;

  int get newSignups => _newSignups;

  String? get error => _error;

  /// Loads last 30 days of stats and new signup count
  Future<void> loadStats() async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final to = DateTime.now();
      final from = to.subtract(const Duration(days: 30));

      // Run queries in parallel for better performance
      final results = await Future.wait([
        _supabase.fetchDailyStats(from, to),
        _supabase.countNewSignupsLast7Days(),
      ]);

      _stats = results[0] as List<DailyStats>;
      _newSignups = results[1] as int;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
