import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://ndvhoqjuzabfhdqdvrjf.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5kdmhvcWp1emFiZmhkcWR2cmpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyMjE4ODIsImV4cCI6MjA3Njc5Nzg4Mn0.5XtNfz_oiwzuAHiwN9DXH9V2PRO0Wi4lqbpynmIcSZE';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  /// Performs Google Sign In natively on Android/iOS and links it with Supabase.
  /// IMPORTANT: You MUST replace 'YOUR_WEB_CLIENT_ID' with the actual Web Client ID from Google Cloud Console.
  static Future<AuthResponse> nativeGoogleSignIn() async {
    // TODO: Replace with your actual Web Client ID from Google Cloud
    const webClientId = 'YOUR_WEB_CLIENT_ID';

    // Optional: Also add iOS client ID if you plan to support iOS
    // const iosClientId = 'YOUR_IOS_CLIENT_ID';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
      // clientId: iosClientId,
    );

    // Prompt the user to select their Google account
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Google Sign In was canceled by the user.';
    }

    // Get the authentication details (ID Token and Access Token)
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    // Sign in to Supabase using the ID Token
    return await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
