import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../models/service_center_model.dart';
import '../scan/scan_screen.dart';
import '../card_purchase/card_purchase_screen.dart';

class ServiceCenterDetailScreen extends StatelessWidget {
  final ServiceCenterModel serviceCenter;

  const ServiceCenterDetailScreen({
    super.key,
    required this.serviceCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: serviceCenter.imageUrl.startsWith('assets/')
                  ? Image.asset(
                      serviceCenter.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.lightGreyColor,
                        child: Icon(
                          Icons.local_car_wash,
                          size: 80,
                          color: AppTheme.greyColor,
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: serviceCenter.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.lightGreyColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.lightGreyColor,
                        child: Icon(
                          Icons.local_car_wash,
                          size: 80,
                          color: AppTheme.greyColor,
                        ),
                      ),
                    ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service center details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        serviceCenter.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Self operation store badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Self Operation Store',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Business hours
                      _buildInfoRow(
                        icon: Icons.access_time,
                        title: 'Business Hours',
                        value: serviceCenter.businessHours,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Location
                      _buildInfoRow(
                        icon: Icons.location_on,
                        title: 'Location',
                        value: serviceCenter.location,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Contact
                      _buildInfoRow(
                        icon: Icons.phone,
                        title: 'Contact Number',
                        value: serviceCenter.contactNumber,
                        trailing: IconButton(
                          icon: Icon(
                            Icons.phone_in_talk,
                            color: AppTheme.primaryColor,
                          ),
                          onPressed: () => _makePhoneCall(serviceCenter.contactNumber),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Description
                      if (serviceCenter.description.isNotEmpty) ...[
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          serviceCenter.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.greyColor,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      
                      // Membership cards section
                      const Text(
                        'Membership Card Special Offers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Horizontal membership cards
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: serviceCenter.membershipCards.length,
                    itemBuilder: (context, index) {
                      return _buildMembershipCard(
                        context,
                        serviceCenter.membershipCards[index],
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Scan code button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ScanScreen()),
                        );
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan Code'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.greyColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildMembershipCard(BuildContext context, MembershipCard card) {
    Color cardColor;
    switch (card.type) {
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

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cardColor, cardColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card icon
            Icon(
              Icons.card_membership,
              color: Colors.white,
              size: 32,
            ),
            
            const SizedBox(height: 12),
            
            // Card name
            Text(
              card.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Days
            Text(
              '${card.days} days',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            
            const Spacer(),
            
            // Price
            Row(
              children: [
                Text(
                  '\$${card.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                if (card.originalPrice != null)
                  Text(
                    '\$${card.originalPrice!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Buy now button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CardPurchaseScreen(
                        selectedServiceCenter: serviceCenter,
                        selectedCard: card,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: cardColor,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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



