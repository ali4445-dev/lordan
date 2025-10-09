// lib/services/auth_service.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class AuthService {
  // Email / Password signup
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    return res;
  }

  // Email / Password sign in
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    final res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res;
  }

  // Magic Link or OTP via email
  Future<void> sendEmailOtp(String email, {String? redirectTo}) async {
    await _supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: redirectTo,
    );
    // No return value — this just sends the OTP / magic link
  }

  // Phone (SMS) OTP sign in
  Future<void> sendSmsOtp(String phone) async {
    final response = await _supabase.auth.signInWithOtp(phone: phone);
  }

  // OAuth (Google, Apple, GitHub, etc.)
  // Future<void> signInWithProvider(OAuthProvider provider,
  //     {String? redirectTo}) async {
  //   // Example:
  //   // await AuthService().signInWithProvider(OAuthProvider.google, redirectTo: kIsWeb ? null : 'io.yourapp://login-callback/');
  //   return await _supabase.auth.signInWithOAuth(
  //     provider,
  //     redirectTo: redirectTo,
  //     // optionally set scopes or authScreenLaunchMode
  //   );
  // }

  Future<AuthResponse> nativeGoogleSignIn() async {
    await dotenv.load(fileName: ".env");
    final supabase = Supabase.instance.client;

    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    final webClientId = dotenv.env['WEB_CLIENT_ID']!;

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    final iosClientId = dotenv.env['IOS_CLIENT_ID']!;

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
    print("Signed in with id ${idToken} and access ${accessToken}");
    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Current session & user
  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;

  // Manual refresh (if needed)
  Future<Session?> refreshSession() async {
    final res = await _supabase.auth.refreshSession();
    return res.session;
  }

  // Set session manually with refresh token (server-to-server handover)
  Future<AuthResponse> setSessionWithRefreshToken(String refreshToken) async {
    return await _supabase.auth.setSession(refreshToken);
  }

  // Listen to auth state changes
  void listenToAuthChanges(void Function(AuthChangeEvent, Session?) callback) {
    _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      callback(event, session);
    });
  }
}
