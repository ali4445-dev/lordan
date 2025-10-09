import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// COMPONENT: AuthProvider
/// Mock authentication provider with no real backend integration
class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  // Authentication state
  Session? _session;
  String? _email;
  User? _user;
  String _plan = 'Free';
  bool _isLoading = false;

  // Getters
  Session? get getSession => _session;
  String? get getEmail => _email;
  User? get getUser => _user;
  String get plan => _plan;
  bool get isLoading => _isLoading;
  bool get isSignedIn => _email != null;

  /// COMPONENT: Mock Email Sign In
  /// Simulates email authentication with loading state
  Future<void> mockSignInEmail(String email, String password) async {}

  Future<void> sendEmailOtp({String? email}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    if (email != null) {
      _email = email;
    }

    // Simulate network delay
    await Supabase.instance.client.auth.signInWithOtp(email: getEmail);

    // _password = password;
    // Supabase.instance.client.auth
    //     .signInWithPassword(password: password, email: _email);
    _isLoading = false;
    notifyListeners();
    // Send

// Verify
  }

  Future<void> verifyEmailOtp(String userOtp) async {
    final response = await Supabase.instance.client.auth.verifyOTP(
      type: OtpType.email,
      email: getEmail,
      token: userOtp,
    );

    if (response.session != null) {
      print('✅ Logged in via OTP code');
    }
  }

  // Future<void> verifySmsOtp() async {

  //   _supabase.auth.verifyOTP(type: OtpType.sms,phone: phone,)
  // }

  /// COMPONENT: Mock Google Sign In
  /// Simulates Google OAuth with loading state
  Future<void> mockSignInGoogle() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    _email = 'user@gmail.com';
    _isLoading = false;
    notifyListeners();
  }

  /// COMPONENT: Mock Apple Sign In
  /// Simulates Apple Sign In with loading state
  Future<void> mockSignInApple() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    _email = 'user@icloud.com';
    _isLoading = false;
    notifyListeners();
  }

  /// COMPONENT: Mock Sign Out
  /// Simulates sign out process with loading state
  Future<void> mockSignOut() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    _email = null;
    _isLoading = false;
    notifyListeners();
  }

  /// COMPONENT: Set Plan (for demo purposes)
  /// Updates the user's plan status
  void setPlan(String newPlan) {
    _plan = newPlan;
    notifyListeners();
  }

  /// COMPONENT: Reset Auth State
  /// Resets all authentication state (useful for testing)
  void reset() {
    _email = null;
    _plan = 'Free';
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch current session (restored from secure storage if available)
      final currentSession = _supabase.auth.currentSession;

      if (currentSession != null) {
        _session = currentSession;
        _user = currentSession.user;
        debugPrint('✅ Existing session restored for: ${_user?.email}');
      } else {
        _session = null;
        _user = null;
        debugPrint('ℹ️ No session found. User needs to log in.');
      }
    } catch (e) {
      debugPrint('❌ Error restoring session: $e');
      _session = null;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🚪 Sign out method
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _session = null;
    _user = null;
    notifyListeners();
  }
}
