import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme.dart';
import '../../models/service_center_model.dart';
import '../../providers/location_provider.dart';
import '../../services/firestore_service.dart';
import '../service_center/service_center_detail_screen.dart';
import '../card_purchase/card_purchase_screen.dart';
import '../vehicle/add_vehicle_screen.dart';
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
        title: const Text('Washtron'),
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

            SizedBox(height: 20.h),

            // Action buttons
            _buildActionButtons(),

            SizedBox(height: 30.h),

            // Closest to me section
            _buildSectionTitle('Closest to Me'),
            _buildServiceCentersList(isClosest: true),

            SizedBox(height: 30.h),

            // Common washing stations
            _buildSectionTitle('Common Washing Stations'),
            _buildServiceCentersList(isClosest: false),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.h,
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
              decoration: BoxDecoration(color: AppTheme.lightGreyColor),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppTheme.lightGreyColor,
                  child: Center(
                    child: Icon(
                      Icons.local_car_wash,
                      size: 60.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 12.w),
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
          SizedBox(width: 8.w),
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
          SizedBox(width: 8.w),
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
            height: 115.h,
            padding: EdgeInsets.all(10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 34.sp, color: AppTheme.primaryColor),
                SizedBox(height: 6.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
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
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
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
          centers.sort(
            (a, b) => (a.distance ?? 999).compareTo(b.distance ?? 999),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
        margin: EdgeInsets.only(bottom: 12.h),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _buildServiceCenterImage(center.imageUrl, 80.w, 80.w),
              ),

              SizedBox(width: 12.w),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      center.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.sp,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            center.location,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.greyColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: center.isInBusiness
                                ? AppTheme.successColor
                                : AppTheme.greyColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            center.isInBusiness ? 'In Business' : 'Closed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (center.distance != null) ...[
                          SizedBox(width: 8.w),
                          Text(
                            '${center.distance!.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 12.sp,
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

  Widget _buildServiceCenterImage(
    String imageUrl,
    double width,
    double height,
  ) {
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
