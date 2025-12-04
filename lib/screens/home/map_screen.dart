import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/service_center_model.dart';
import '../../services/firestore_service.dart';
import '../../providers/location_provider.dart';
import '../service_center/service_center_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final MapController _mapController = MapController();
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Within 5km', 'Within 10km', 'Within 20km'];
  
  // Colombo, Sri Lanka coordinates
  static const LatLng _colomboCenter = LatLng(6.9271, 79.8612);
  double _currentZoom = 12.0;
  LatLng _currentCenter = _colomboCenter;

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Stations'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (locationProvider.currentPosition != null) {
                _mapController.move(
                  LatLng(
                    locationProvider.currentPosition!.latitude,
                    locationProvider.currentPosition!.longitude,
                  ),
                  14.0,
                );
              } else {
                _mapController.move(_colomboCenter, 12.0);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Flutter Map with OpenStreetMap
          StreamBuilder<List<ServiceCenterModel>>(
            stream: _firestoreService.getServiceCenters(),
            builder: (context, snapshot) {
              List<Marker> markers = [];
              
              // Add user location marker
              if (locationProvider.currentPosition != null) {
                markers.add(
                  Marker(
                    point: LatLng(
                      locationProvider.currentPosition!.latitude,
                      locationProvider.currentPosition!.longitude,
                    ),
                    width: 40.w,
                    height: 40.h,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 30.sp,
                    ),
                  ),
                );
              }
              
              // Add service center markers
              if (snapshot.hasData) {
                final centers = snapshot.data!;
                
                // Calculate distances and filter
                List<ServiceCenterModel> filteredCenters = centers;
                if (locationProvider.currentPosition != null) {
                  for (var center in centers) {
                    center.distance = locationProvider.calculateDistance(
                      locationProvider.currentPosition!.latitude,
                      locationProvider.currentPosition!.longitude,
                      center.latitude,
                      center.longitude,
                    );
                  }
                  
                  // Apply distance filter
                  if (_selectedFilter == 'Within 5km') {
                    filteredCenters = centers.where((c) => (c.distance ?? 999) <= 5).toList();
                  } else if (_selectedFilter == 'Within 10km') {
                    filteredCenters = centers.where((c) => (c.distance ?? 999) <= 10).toList();
                  } else if (_selectedFilter == 'Within 20km') {
                    filteredCenters = centers.where((c) => (c.distance ?? 999) <= 20).toList();
                  }
                }
                
                for (var center in filteredCenters) {
                  // Determine marker color based on distance
                  Color markerColor;
                  if (center.distance == null) {
                    markerColor = AppTheme.primaryColor;
                  } else if (center.distance! <= 5) {
                    markerColor = Colors.green;
                  } else if (center.distance! <= 10) {
                    markerColor = Colors.orange;
                  } else if (center.distance! <= 20) {
                    markerColor = Colors.blue;
                  } else {
                    markerColor = AppTheme.primaryColor;
                  }
                  
                  // Don't show if not in business
                  if (!center.isInBusiness) {
                    markerColor = Colors.grey;
                  }
                  
                  markers.add(
                    Marker(
                      point: LatLng(center.latitude, center.longitude),
                      width: 90.w,
                      height: 90.h,
                      child: GestureDetector(
                        onTap: () => _showCenterPreview(center),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: markerColor, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (center.distance != null) ...[
                                    Text(
                                      '${center.distance!.toStringAsFixed(1)}km',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9.sp,
                                        color: markerColor,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                  ],
                                  Flexible(
                                    child: Text(
                                      center.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.sp,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: markerColor,
                                  size: 40.sp,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 8.h,
                                  child: Icon(
                                    Icons.local_car_wash,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
              
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentCenter,
                  initialZoom: _currentZoom,
                  minZoom: 8.0,
                  maxZoom: 18.0,
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture) {
                      setState(() {
                        _currentCenter = position.center!;
                        _currentZoom = position.zoom!;
                      });
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.hbuilder.app',
                    maxZoom: 19,
                  ),
                  MarkerLayer(markers: markers),
                  // Highlight Colombo region
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _colomboCenter,
                        radius: 15000, // 15km radius
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderColor: AppTheme.primaryColor.withOpacity(0.3),
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          // Filter Chips
          Positioned(
            top: 16.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: FilterChip(
                          avatar: Icon(
                            Icons.location_on,
                            size: 18.sp,
                            color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
                          ),
                          label: Text(
                            filter,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryColor : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.h),
                // Color Legend
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLegendItem(Colors.green, '0-5km'),
                      SizedBox(width: 12.w),
                      _buildLegendItem(Colors.orange, '5-10km'),
                      SizedBox(width: 12.w),
                      _buildLegendItem(Colors.blue, '10-20km'),
                      SizedBox(width: 12.w),
                      _buildLegendItem(Colors.grey, 'Closed'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            mini: true,
            onPressed: () {
              _mapController.move(_currentCenter, _currentZoom + 1);
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: Colors.black),
          ),
          SizedBox(height: 8.h),
          FloatingActionButton(
            heroTag: 'zoom_out',
            mini: true,
            onPressed: () {
              _mapController.move(_currentCenter, _currentZoom - 1);
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.remove, color: Colors.black),
          ),
          SizedBox(height: 8.h),
          FloatingActionButton(
            heroTag: 'recenter',
            onPressed: () {
              final locationProvider = context.read<LocationProvider>();
              if (locationProvider.currentPosition != null) {
                _mapController.move(
                  LatLng(
                    locationProvider.currentPosition!.latitude,
                    locationProvider.currentPosition!.longitude,
                  ),
                  14.0,
                );
              } else {
                _mapController.move(_colomboCenter, 12.0);
              }
            },
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.location_on,
          color: color,
          size: 16.sp,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showCenterPreview(ServiceCenterModel center) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(16.w),
              leading: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppTheme.lightGreyColor,
                  image: center.imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: center.imageUrl.startsWith('assets') 
                              ? AssetImage(center.imageUrl) as ImageProvider
                              : NetworkImage(center.imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: center.imageUrl.isEmpty 
                    ? const Icon(Icons.local_car_wash) 
                    : null,
              ),
              title: Text(
                center.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              subtitle: Text(center.location, style: TextStyle(fontSize: 13.sp)),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceCenterDetailScreen(serviceCenter: center),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Navigate'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceCenterDetailScreen(serviceCenter: center),
                          ),
                        );
                      },
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

