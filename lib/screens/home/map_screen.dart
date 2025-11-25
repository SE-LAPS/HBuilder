import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/service_center_model.dart';
import '../../services/firestore_service.dart';
import '../service_center/service_center_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Available', 'Self Service', 'Full Service'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Stations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Simulated Map Background
          Container(
            color: const Color(0xFFE5E3DF), // Google Maps background color
            child: Center(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/logos/Washtron Orange BG Without tagline -01.png', // Placeholder watermark
                  width: 300,
                ),
              ),
            ),
          ),
          
          // Grid lines to simulate map
          CustomPaint(
            size: Size.infinite,
            painter: MapGridPainter(),
          ),

          // Service Center Markers
          StreamBuilder<List<ServiceCenterModel>>(
            stream: _firestoreService.getServiceCenters(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final centers = snapshot.data!;
              // Filter logic (mocked for now as data might not have these fields)
              final filteredCenters = _selectedFilter == 'All' 
                  ? centers 
                  : centers; // Implement actual filtering if model supports it

              return Stack(
                children: filteredCenters.asMap().entries.map((entry) {
                  final index = entry.key;
                  final center = entry.value;
                  
                  // Pseudo-random positioning for demo purposes
                  // In a real app, use GoogleMap markers with LatLng
                  final double top = 100.0 + (index * 150) % 400;
                  final double left = 50.0 + (index * 100) % 300;

                  return Positioned(
                    top: top,
                    left: left,
                    child: GestureDetector(
                      onTap: () => _showCenterPreview(center),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              center.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // Filter Chips
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
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
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Re-center map (mock)
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.my_location, color: Colors.black),
      ),
    );
  }

  void _showCenterPreview(ServiceCenterModel center) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(center.location),
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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Navigate'),
                    ),
                  ),
                  const SizedBox(width: 12),
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

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    const double gridSize = 40;

    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
