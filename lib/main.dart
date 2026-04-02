import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import 'screens/home_screen.dart';
import 'screens/permission_screen.dart';

const String _supabaseUrl =
    'https://siujmsbmvwxxbdhlihgd.supabase.co';
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
      home: const SplashRouter(),
    );
  }
}

/// Checks notification permission and routes to the correct screen.
/// Shows a loading indicator while checking — never a blank screen.
class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    _checkAndRoute();
  }

  Future<void> _checkAndRoute() async {
    bool hasPermission = false;
    try {
      hasPermission =
          await NotificationListenerService.isPermissionGranted();
    } catch (_) {
      hasPermission = false;
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            hasPermission ? const HomeScreen() : const PermissionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
