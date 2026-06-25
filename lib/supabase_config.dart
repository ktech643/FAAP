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
}
