import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../models/service_center_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class CardPurchaseScreen extends StatefulWidget {
  final ServiceCenterModel? selectedServiceCenter;
  final MembershipCard? selectedCard;

  const CardPurchaseScreen({
    super.key,
    this.selectedServiceCenter,
    this.selectedCard,
  });

  @override
  State<CardPurchaseScreen> createState() => _CardPurchaseScreenState();
}

class _CardPurchaseScreenState extends State<CardPurchaseScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  ServiceCenterModel? _selectedServiceCenter;
  MembershipCard? _selectedCard;
  List<ServiceCenterModel> _serviceCenters = [];

  @override
  void initState() {
    super.initState();
    _selectedServiceCenter = widget.selectedServiceCenter;
    _selectedCard = widget.selectedCard;
    _loadServiceCenters();
  }

  Future<void> _loadServiceCenters() async {
    _firestoreService.getServiceCenters().listen((centers) {
      if (mounted) {
        setState(() {
          _serviceCenters = centers;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Purchase'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected service center (if any)
            if (_selectedServiceCenter != null)
              _buildSelectedServiceCenter(),
            
            // Membership cards selection
            _buildMembershipCardsSection(),
            
            // Notes
            _buildNotesSection(),
            
            // Applicable stores
            _buildApplicableStoresSection(),
            
            // Card purchase notice
            _buildPurchaseNotice(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSelectedServiceCenter() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGreyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Service Center',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedServiceCenter!.name,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCardsSection() {
    final cards = [
      {'type': 'monthly', 'name': 'Monthly Card', 'days': 30, 'price': 159.0},
      {'type': 'seasonal', 'name': 'Seasonal Card', 'days': 90, 'price': 299.0, 'originalPrice': 1080.0},
      {'type': 'annual', 'name': 'Annual Card', 'days': 360, 'price': 498.0, 'originalPrice': 6220.0},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Select Membership Card',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            final isSelected = _selectedCard?.type == card['type'];
            
            Color cardColor;
            switch (card['type']) {
              case 'monthly':
                cardColor = const Color(0xFF2196F3);
                break;
              case 'seasonal':
                cardColor = const Color(0xFF4CAF50);
                break;
              case 'annual':
                cardColor = const Color(0xFFFF9800);
                break;
              default:
                cardColor = AppTheme.primaryColor;
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCard = MembershipCard(
                    type: card['type'] as String,
                    name: card['name'] as String,
                    days: card['days'] as int,
                    price: card['price'] as double,
                    originalPrice: card['originalPrice'] as double?,
                    imageUrl: '',
                  );
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? cardColor.withOpacity(0.1) : Colors.white,
                  border: Border.all(
                    color: isSelected ? cardColor : AppTheme.greyColor.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.card_membership,
                      color: cardColor,
                      size: 40,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card['name'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: cardColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${card['days']} days',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${card['price']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: cardColor,
                          ),
                        ),
                        if (card['originalPrice'] != null)
                          Text(
                            '\$${card['originalPrice']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.greyColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Important Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '* Please select a store before purchasing membership',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.greyColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '* The minimum cost for a single transaction is only \$8.9',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicableStoresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Applicable Stores (${_serviceCenters.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _serviceCenters.length,
          itemBuilder: (context, index) {
            final center = _serviceCenters[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.store, color: AppTheme.primaryColor),
                title: Text(center.name),
                subtitle: Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: AppTheme.greyColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        center.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (center.distance != null)
                      Text('${center.distance!.toStringAsFixed(1)} km'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.phone, color: AppTheme.primaryColor),
                  onPressed: () => _makePhoneCall(center.contactNumber),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPurchaseNotice() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGreyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Purchase Notice',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'By purchasing a membership card, you agree to our terms and conditions. '
            'The card is valid for the specified duration from the date of purchase. '
            'Unused services cannot be refunded. Please visit any applicable store '
            'to use your membership benefits.',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.greyColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final canPurchase = _selectedServiceCenter != null && _selectedCard != null;
    final price = _selectedCard?.price ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canPurchase ? _processPurchase : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              disabledBackgroundColor: AppTheme.greyColor,
            ),
            child: Text(
              canPurchase 
                  ? 'Recharge Now - \$${price.toStringAsFixed(0)}'
                  : 'Select Card and Store',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _processPurchase() async {
    final authProvider = context.read<AuthProvider>();
    
    if (authProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to purchase')),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await _firestoreService.addPurchaseHistory(
        userId: authProvider.user!.uid,
        serviceCenterId: _selectedServiceCenter!.id,
        cardType: _selectedCard!.type,
        amount: _selectedCard!.price,
      );

      if (!mounted) return;
      
      Navigator.pop(context); // Close loading
      
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppTheme.successColor),
              const SizedBox(width: 8),
              const Text('Purchase Successful'),
            ],
          ),
          content: const Text(
            'Your membership card has been purchased successfully! '
            'You can now use it at the selected service center.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}



