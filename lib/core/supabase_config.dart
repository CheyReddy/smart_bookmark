import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'supabaseurl', 
      anonKey: 'anonkey',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
