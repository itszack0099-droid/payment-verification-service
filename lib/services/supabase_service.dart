import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {

  static const supabaseUrl =
      'https://siujmsbmvwxxbdhlihgd.supabase.co';

  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im90c2JicWxwcmNvYWRibXZneHZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ4ODQwMDksImV4cCI6MjA5MDQ2MDAwOX0.bxp0A54tll6fYMd3_ahPt6eOGDwIBt-o1-u6FpNxBg4';

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client =>
      Supabase.instance.client;
}
