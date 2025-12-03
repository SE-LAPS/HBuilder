import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About App')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // App Icon
          Center(
            child: Icon(
              Icons.car_repair,
              size: 100,
              color: AppTheme.primaryColor,
            ),
          ),

          const SizedBox(height: 20),

          // App Name
          const Text(
            'Washtron',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // Version
          Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppTheme.greyColor),
          ),

          const SizedBox(height: 40),

          // Description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Washtron',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Washtron is your ultimate car wash and service management app. '
                    'Find nearby service centers, purchase membership cards, '
                    'manage your vehicles, and enjoy exclusive benefits.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.greyColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Features
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Features',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFeature(
                    Icons.location_on,
                    'Find nearby service centers',
                  ),
                  _buildFeature(
                    Icons.card_membership,
                    'Purchase membership cards',
                  ),
                  _buildFeature(Icons.qr_code_scanner, 'QR/Barcode scanning'),
                  _buildFeature(Icons.directions_car, 'Vehicle management'),
                  _buildFeature(Icons.business, 'Franchise opportunities'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Links
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text('Privacy Policy'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppTheme.greyColor,
                  ),
                  onTap: () => _launchURL('https://hbuilder.com/privacy'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.description,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text('Terms of Service'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppTheme.greyColor,
                  ),
                  onTap: () => _launchURL('https://hbuilder.com/terms'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.web, color: AppTheme.primaryColor),
                  title: const Text('Visit Website'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppTheme.greyColor,
                  ),
                  onTap: () => _launchURL('https://hbuilder.com'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Copyright
          Text(
            '© 2025 Washtron. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppTheme.greyColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
