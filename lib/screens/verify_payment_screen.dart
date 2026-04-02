import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyPaymentScreen extends StatefulWidget {
  const VerifyPaymentScreen({super.key});

  @override
  State<VerifyPaymentScreen> createState() => _VerifyPaymentScreenState();
}

class _VerifyPaymentScreenState extends State<VerifyPaymentScreen> {
  final _requestIdController = TextEditingController();
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _status;
  String? _errorMessage;

  @override
  void dispose() {
    _requestIdController.dispose();
    super.dispose();
  }

  Future<void> _verifyPayment() async {
    final requestId = _requestIdController.text.trim();
    if (requestId.isEmpty) {
      setState(() => _errorMessage = 'Please enter a Request ID.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _status = null;
    });

    try {
      final response = await _supabase.rpc(
        'check_payment_status',
        params: {'request_id': requestId},
      );

      final data = (response is List) ? response[0] : response;
      final status =
          (data is String) ? data : data['status']?.toString() ?? 'unknown';
      setState(() => _status = status.toLowerCase());
    } catch (_) {
      setState(() => _errorMessage = 'Unable to connect to payment server.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'approved':
        return Colors.green;
      case 'expired':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusMessage(String s) {
    switch (s) {
      case 'approved':
        return 'Payment approved. Subscription activated.';
      case 'expired':
        return 'Payment expired. Please try again.';
      default:
        return 'Status: $s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Verify Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _requestIdController,
              decoration: const InputDecoration(
                labelText: 'Request ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _verifyPayment,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Verify Payment'),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            ],

            if (_status != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _statusColor(_status!).withOpacity(0.08),
                  border: Border.all(
                      color: _statusColor(_status!).withOpacity(0.35)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      _status == 'approved'
                          ? Icons.check_circle_outline
                          : _status == 'expired'
                              ? Icons.cancel_outlined
                              : Icons.access_time,
                      color: _statusColor(_status!),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _statusMessage(_status!),
                        style: TextStyle(
                          color: _statusColor(_status!),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
