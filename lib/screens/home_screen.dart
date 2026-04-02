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

    // Run after UI loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPermission();
    });
  }

  Future<void> checkPermission() async {
    var status = await Permission.notification.status;

    if (!status.isGranted) {
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

    // THIS guarantees screen never blank

    return Scaffold(
      appBar: AppBar(
        title: const Text("PaymentVerifier"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Service Ready",
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                print("Create Payment clicked");
              },
              child: const Text("Create Payment"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                print("Verify Payment clicked");
              },
              child: const Text("Verify Payment"),
            ),

          ],
        ),
      ),
    );
  }
}