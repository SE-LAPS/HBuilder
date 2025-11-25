import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';
import '../../models/service_center_model.dart';
import '../../providers/location_provider.dart';
import '../../services/firestore_service.dart';
import '../service_center/service_center_detail_screen.dart';
import '../card_purchase/card_purchase_screen.dart';
import '../vehicle/add_vehicle_screen.dart';
import '../franchise/franchise_application_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final List<String> _bannerImages = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
    'assets/images/banner4.jpg',
    'assets/images/banner5.jpg',
    'assets/images/banner6.jpg',
    'assets/images/banner7.jpg',
    'assets/images/banner8.jpg',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HBuilder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner carousel
            _buildBannerCarousel(),
            
            const SizedBox(height: 20),
            
            // Action buttons
            _buildActionButtons(),
            
            const SizedBox(height: 30),
            
            // Closest to me section
            _buildSectionTitle('Closest to Me'),
            _buildServiceCentersList(isClosest: true),
            
            const SizedBox(height: 30),
            
            // Common washing stations
            _buildSectionTitle('Common Washing Stations'),
            _buildServiceCentersList(isClosest: false),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
      items: _bannerImages.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: AppTheme.lightGreyColor,
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppTheme.lightGreyColor,
                  child: Center(
                    child: Icon(
                      Icons.local_car_wash,
                      size: 60,
                      color: AppTheme.greyColor,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.map,
            label: 'Find Stations',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MapScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: Icons.card_membership,
            label: 'Card Purchase',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CardPurchaseScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: Icons.directions_car,
            label: 'Add Vehicle',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddVehicleScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Container(
            height: 110,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.secondaryColor,
        ),
      ),
    );
  }

  Widget _buildServiceCentersList({required bool isClosest}) {
    return StreamBuilder<List<ServiceCenterModel>>(
      stream: _firestoreService.getServiceCenters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'No service centers available',
                style: TextStyle(color: AppTheme.greyColor),
              ),
            ),
          );
        }

        List<ServiceCenterModel> centers = snapshot.data!;
        
        // Calculate distances
        final locationProvider = context.watch<LocationProvider>();
        if (locationProvider.currentPosition != null) {
          for (var center in centers) {
            center.distance = locationProvider.calculateDistance(
              locationProvider.currentPosition!.latitude,
              locationProvider.currentPosition!.longitude,
              center.latitude,
              center.longitude,
            );
          }
          
          // Sort by distance
          centers.sort((a, b) => (a.distance ?? 999).compareTo(b.distance ?? 999));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: centers.length,
          itemBuilder: (context, index) {
            return _buildServiceCenterCard(centers[index]);
          },
        );
      },
    );
  }

  Widget _buildServiceCenterCard(ServiceCenterModel center) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceCenterDetailScreen(serviceCenter: center),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildServiceCenterImage(center.imageUrl, 80, 80),
              ),
              
              const SizedBox(width: 12),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      center.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            center.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.greyColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: center.isInBusiness
                                ? AppTheme.successColor
                                : AppTheme.greyColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            center.isInBusiness ? 'In Business' : 'Closed',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (center.distance != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${center.distance!.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.greyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCenterImage(String imageUrl, double width, double height) {
    // Check if it's an asset or network image
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: AppTheme.lightGreyColor,
          child: Icon(Icons.local_car_wash, color: AppTheme.greyColor),
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: AppTheme.lightGreyColor,
          child: Icon(Icons.local_car_wash, color: AppTheme.greyColor),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppTheme.lightGreyColor,
          child: Icon(Icons.local_car_wash, color: AppTheme.greyColor),
        ),
      );
    }
  }
}



