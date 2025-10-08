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
    final cardType = purchase['cardType'] ?? '';
    final amount = purchase['amount'] ?? 0.0;
    final timestamp = purchase['purchasedAt'];
    
    String cardName;
    Color cardColor;
    switch (cardType) {
      case 'monthly':
        cardName = 'Monthly Card';
        cardColor = const Color(0xFF2196F3);
        break;
      case 'seasonal':
        cardName = 'Seasonal Card';
        cardColor = const Color(0xFF4CAF50);
        break;
      case 'annual':
        cardName = 'Annual Card';
        cardColor = const Color(0xFFFF9800);
        break;
      default:
        cardName = 'Membership Card';
        cardColor = AppTheme.primaryColor;
    }

    String dateStr = 'Recently';
    if (timestamp != null) {
      final date = timestamp.toDate();
      dateStr = DateFormat('MMM dd, yyyy - HH:mm').format(date);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cardColor,
          child: const Icon(
            Icons.card_membership,
            color: Colors.white,
          ),
        ),
        title: Text(
          cardName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          dateStr,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.greyColor,
          ),
        ),
        trailing: Text(
          '\$${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: cardColor,
          ),
        ),
      ),
    );
  }
}



