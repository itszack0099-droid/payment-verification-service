import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    // Delay so UI loads first
    Future.delayed(const Duration(milliseconds: 500), () {
      checkPermission();
    });
  }

  Future<void> checkPermission() async {
    bool enabled = await Permission.notification.isGranted;

    if (!enabled) {
      showPermissionDialog();
    }
  }

  void showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Notification Permission"),
          content: const Text(
            "Notification permission is required for payment verification.",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Deny"),
            ),

            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
                Navigator.pop(context);
              },
              child: const Text("Allow"),
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Verification Service"),
      ),
      body: const Center(
        child: Text(
          "Service Ready",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}