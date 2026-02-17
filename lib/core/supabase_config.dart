import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://syugxucqqpaabbmolgsz.supabase.co', 
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5dWd4dWNxcXBhYWJibW9sZ3N6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA5MDI5OTMsImV4cCI6MjA4NjQ3ODk5M30.UAOMNZeUI5l94w4lv3ewj3Cz_ZeVqLOEZpH9KN0pHtE',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}