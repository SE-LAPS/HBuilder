import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class FranchiseApplicationScreen extends StatefulWidget {
  const FranchiseApplicationScreen({super.key});

  @override
  State<FranchiseApplicationScreen> createState() =>
      _FranchiseApplicationScreenState();
}

class _FranchiseApplicationScreenState
    extends State<FranchiseApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _cityController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Accession')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Info Section
            _buildCompanyInfoSection(),

            const SizedBox(height: 30),

            // Application Form
            _buildApplicationForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.business, color: Colors.white, size: 40),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Washtron Franchise',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Join our growing network',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Company Address
        _buildInfoCard(
          icon: Icons.location_on,
          title: 'Company Address',
          value: '123 Business Street, Downtown\nCity Center, State 12345',
        ),

        const SizedBox(height: 12),

        // Working Hours
        _buildInfoCard(
          icon: Icons.access_time,
          title: 'Working Hours',
          value:
              'Monday - Friday: 9:00 AM - 6:00 PM\nSaturday: 10:00 AM - 4:00 PM',
        ),

        const SizedBox(height: 12),

        // Contact Phone
        _buildInfoCard(
          icon: Icons.phone,
          title: 'Contact Phone',
          value: '+1 (555) 123-4567',
          trailing: IconButton(
            icon: Icon(Icons.phone_in_talk, color: AppTheme.primaryColor),
            onPressed: () => _makePhoneCall('+15551234567'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.greyColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fill Application Form',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Contact Number
          TextFormField(
            controller: _contactController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Contact Number',
              hintText: 'Enter your phone number',
              prefixIcon: Icon(Icons.phone),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your contact number';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Franchise City
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'Franchise City',
              hintText: 'Enter desired franchise city',
              prefixIcon: Icon(Icons.location_city),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter franchise city';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Message
          TextFormField(
            controller: _messageController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Leave a Message',
              hintText: 'Tell us why you want to join our franchise...',
              prefixIcon: Icon(Icons.message),
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please leave a message';
              }
              return null;
            },
          ),

          const SizedBox(height: 30),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitApplication,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Submit Application'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();

      if (authProvider.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to submit application')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        await _firestoreService.submitFranchiseApplication(
          name: _nameController.text.trim(),
          contactNumber: _contactController.text.trim(),
          franchiseCity: _cityController.text.trim(),
          message: _messageController.text.trim(),
          userId: authProvider.user!.uid,
        );

        if (!mounted) return;

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.successColor),
                const SizedBox(width: 8),
                const Text('Application Submitted'),
              ],
            ),
            content: const Text(
              'Thank you for your interest! Your franchise application has been '
              'submitted successfully. Our team will review your application and '
              'contact you within 3-5 business days.',
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

        // Clear form
        _nameController.clear();
        _contactController.clear();
        _cityController.clear();
        _messageController.clear();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _cityController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
