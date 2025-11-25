import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getPurchaseHistory(authProvider.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: AppTheme.greyColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No purchase history',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.greyColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final purchase = snapshot.data![index];
              return _buildHistoryItem(purchase);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> purchase) {
    final type = purchase['cardType'] ?? 'service'; // Reusing field for type
    final amount = purchase['amount'] ?? 0.0;
    final timestamp = purchase['purchasedAt'];
    
    String title;
    Color iconColor;
    IconData icon;

    switch (type) {
      case 'monthly':
        title = 'Monthly Card';
        iconColor = const Color(0xFF2196F3);
        icon = Icons.card_membership;
        break;
      case 'seasonal':
        title = 'Seasonal Card';
        iconColor = const Color(0xFF4CAF50);
        icon = Icons.card_membership;
        break;
      case 'annual':
        title = 'Annual Card';
        iconColor = const Color(0xFFFF9800);
        icon = Icons.card_membership;
        break;
      case 'card':
      case 'genie':
      case 'frimi':
        title = 'Service Booking';
        iconColor = AppTheme.primaryColor;
        icon = Icons.local_car_wash;
        break;
      default:
        title = 'Transaction';
        iconColor = Colors.grey;
        icon = Icons.payment;
    }

    String dateStr = 'Recently';
    if (timestamp != null) {
      // Handle Firestore Timestamp or DateTime
      final date = (timestamp as dynamic).toDate();
      dateStr = DateFormat('MMM dd, yyyy - HH:mm').format(date);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.greyColor,
              ),
            ),
            if (type == 'card' || type == 'genie' || type == 'frimi')
              Text(
                'Paid via ${type[0].toUpperCase()}${type.substring(1)}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.greyColor,
                ),
              ),
          ],
        ),
        trailing: Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}



