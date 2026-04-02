import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  bool _notificationEnabled = false;
  bool _serviceRunning = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Re-check when user returns from system settings.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    try {
      final granted =
          await NotificationListenerService.isPermissionGranted();
      if (mounted) setState(() => _notificationEnabled = granted);
    } catch (_) {}
  }

  Future<void> _openNotificationSettings() async {
    try {
      await NotificationListenerService.requestPermission();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _statusRow(
              label: 'Notification Status',
              value: _notificationEnabled ? 'Enabled' : 'Disabled',
              color: _notificationEnabled ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 12),
            _statusRow(
              label: 'Service Status',
              value: _serviceRunning ? 'Running' : 'Stopped',
              color: _serviceRunning ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: _openNotificationSettings,
              child: const Text('Open Notification Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
