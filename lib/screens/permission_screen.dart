import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import 'home_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver {
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Called automatically when the user returns from the Settings screen.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndNavigate();
    }
  }

  Future<void> _checkAndNavigate() async {
    if (_checking) return;
    setState(() => _checking = true);

    try {
      final granted =
          await NotificationListenerService.isPermissionGranted();
      if (granted && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return;
      }
    } catch (_) {}

    if (mounted) setState(() => _checking = false);
  }

  Future<void> _openSettings() async {
    try {
      await NotificationListenerService.requestPermission();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Payment Verification Service',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Notification access is required to detect and verify payment notifications.',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (_checking)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _openSettings,
                    child: const Text('Enable Notification Access'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
