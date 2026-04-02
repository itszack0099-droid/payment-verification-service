import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase safely
  try {
    await SupabaseService.init();
    print("Supabase initialized successfully");
  } catch (e) {
    print("Supabase init error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "PaymentVerifier",

      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),

        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),

      // Safe fallback builder (prevents blank screen)
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Scaffold(
            body: Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ),
          );
        };

        return child!;
      },

      // Start screen
      home: const HomeScreen(),
    );
  }
}