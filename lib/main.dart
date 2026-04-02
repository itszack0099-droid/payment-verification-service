import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_screen.dart';

const String _supabaseUrl = 'https://siujmsbmvwxxbdhlihgd.supabase.co';
const String _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpdWptc2Jtdnd4eGJkaGxpaGdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM1NDQ2MDksImV4cCI6MjA4OTEyMDYwOX0'
    '.WlRm9ySc6huXd7018ESMTtkKS4XLmgBszNO0yvoG2DY';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );

  runApp(const PaymentVerifierApp());
}

class PaymentVerifierApp extends StatelessWidget {
  const PaymentVerifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaymentVerifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
      // Always start on HomeScreen — no permission gate at startup.
      home: const HomeScreen(),
    );
  }
}
