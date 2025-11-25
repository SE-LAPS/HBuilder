import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../main/main_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String serviceCenterName;
  final String description;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.serviceCenterName,
    required this.description,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'card';
  bool _usePoints = false;
  bool _isProcessing = false;
  final FirestoreService _firestoreService = FirestoreService();

  // Mock Points
  final double _availablePoints = 150.0; // 1 Point = $0.10
  final double _pointValue = 0.10;

  @override
  Widget build(BuildContext context) {
    double finalAmount = widget.amount;
    double discount = 0;

    if (_usePoints) {
      double maxDiscount = _availablePoints * _pointValue;
      if (maxDiscount >= finalAmount) {
        discount = finalAmount;
        finalAmount = 0;
      } else {
        discount = maxDiscount;
        finalAmount -= maxDiscount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(color: AppTheme.greyColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(widget.serviceCenterName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.description, style: TextStyle(color: AppTheme.greyColor)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Loyalty Points
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.stars, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Use Loyalty Points',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Available: ${_availablePoints.toInt()} pts (\$${(_availablePoints * _pointValue).toStringAsFixed(2)})',
                          style: TextStyle(fontSize: 12, color: AppTheme.greyColor),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _usePoints,
                    onChanged: (value) {
                      setState(() {
                        _usePoints = value;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Payment Methods
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            _buildPaymentMethod(
              id: 'card',
              title: 'Credit / Debit Card',
              icon: Icons.credit_card,
              subtitle: 'Visa, MasterCard, Amex',
            ),
            _buildPaymentMethod(
              id: 'genie',
              title: 'Genie',
              icon: Icons.phone_android, // Placeholder icon
              subtitle: 'Pay via Genie App',
            ),
            _buildPaymentMethod(
              id: 'frimi',
              title: 'FriMi',
              icon: Icons.account_balance_wallet, // Placeholder icon
              subtitle: 'Pay via FriMi App',
            ),
            
            const SizedBox(height: 30),
            
            // Summary
            if (_usePoints) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal'),
                  Text('\$${widget.amount.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Points Discount', style: TextStyle(color: AppTheme.successColor)),
                  Text('-\$${discount.toStringAsFixed(2)}', style: TextStyle(color: AppTheme.successColor)),
                ],
              ),
              const Divider(height: 24),
            ],
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('To Pay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '\$${finalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Confirm Payment',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({
    required String id,
    required String title,
    required IconData icon,
    required String subtitle,
  }) {
    final isSelected = _selectedMethod == id;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: isSelected 
          ? RoundedRectangleBorder(
              side: BorderSide(color: AppTheme.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(12))
          : null,
      child: RadioListTile(
        value: id,
        groupValue: _selectedMethod,
        onChanged: (value) {
          setState(() {
            _selectedMethod = value.toString();
          });
        },
        title: Row(
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 36),
          child: Text(subtitle),
        ),
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Save to history (Mock)
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      await _firestoreService.addPurchaseHistory(
        userId: authProvider.user!.uid,
        serviceCenterId: 'mock_center_id', // In real app, pass ID
        cardType: _selectedMethod,
        amount: widget.amount,
      );
    }

    if (!mounted) return;

    // Show Success
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: AppTheme.successColor, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Your booking has been confirmed.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainScreen()),
                (route) => false,
              );
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
