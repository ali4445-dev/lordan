import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
