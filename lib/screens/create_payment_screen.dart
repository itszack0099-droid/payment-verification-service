import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CreatePaymentScreen extends StatefulWidget {
  const CreatePaymentScreen({super.key});

  @override
  State<CreatePaymentScreen> createState() => _CreatePaymentScreenState();
}

class _CreatePaymentScreenState extends State<CreatePaymentScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _supabase = Supabase.instance.client;
  final _uuid = const Uuid();

  bool _isLoading = false;
  String? _requestId;
  String? _finalAmount;
  String? _errorMessage;

  static const int _fixedAmount = 149;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _generatePayment() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      setState(() => _errorMessage = 'Please fill in Name and Phone.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _requestId = null;
      _finalAmount = null;
    });

    try {
      final response = await _supabase.rpc(
        'create_payment_request',
        params: {
          'user_id': _uuid.v4(),
          'name': name,
          'phone': phone,
          'amount': _fixedAmount,
        },
      );

      final data = (response is List) ? response[0] : response;
      setState(() {
        _requestId = data['request_id']?.toString() ?? '';
        _finalAmount =
            data['final_amount']?.toString() ?? _fixedAmount.toString();
      });
    } catch (e) {
      setState(() => _errorMessage =
          'Payment request failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Create Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name field
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Phone field
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Fixed amount display
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              child: const Text(
                '₹$_fixedAmount',
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 28),

            // Generate button
            ElevatedButton(
              onPressed: _isLoading ? null : _generatePayment,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Generate Payment'),
            ),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              _messageBox(
                _errorMessage!,
                backgroundColor: Colors.red.shade50,
                borderColor: Colors.red.shade200,
                textColor: Colors.red.shade700,
              ),
            ],

            // Success result
            if (_requestId != null) ...[
              const SizedBox(height: 16),
              _messageBox(
                'Payment request created successfully.',
                backgroundColor: Colors.green.shade50,
                borderColor: Colors.green.shade200,
                textColor: Colors.green.shade800,
                extra: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Request ID: $_requestId',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Final Amount: ₹$_finalAmount'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _messageBox(
    String text, {
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    Widget? extra,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          ),
          if (extra != null) extra,
        ],
      ),
    );
  }
}
