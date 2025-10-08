class ServiceCenterModel {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final double latitude;
  final double longitude;
  final String businessHours;
  final String contactNumber;
  final bool isInBusiness;
  final String description;
  final List<MembershipCard> membershipCards;
  double? distance; // in km

  ServiceCenterModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.businessHours,
    required this.contactNumber,
    required this.isInBusiness,
    required this.description,
    required this.membershipCards,
    this.distance,
  });

  factory ServiceCenterModel.fromMap(Map<String, dynamic> map, String id) {
    return ServiceCenterModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      location: map['location'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      businessHours: map['businessHours'] ?? '00:00 - 24:00',
      contactNumber: map['contactNumber'] ?? '',
      isInBusiness: map['isInBusiness'] ?? true,
      description: map['description'] ?? '',
      membershipCards: (map['membershipCards'] as List<dynamic>?)
              ?.map((e) => MembershipCard.fromMap(e))
              .toList() ??
          [],
      distance: map['distance']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'businessHours': businessHours,
      'contactNumber': contactNumber,
      'isInBusiness': isInBusiness,
      'description': description,
      'membershipCards': membershipCards.map((e) => e.toMap()).toList(),
    };
  }
}

class MembershipCard {
  final String type; // 'monthly', 'seasonal', 'annual'
  final String name;
  final int days;
  final double price;
  final double? originalPrice;
  final String imageUrl;

  MembershipCard({
    required this.type,
    required this.name,
    required this.days,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
  });

  factory MembershipCard.fromMap(Map<String, dynamic> map) {
    return MembershipCard(
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      days: map['days'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      originalPrice: map['originalPrice']?.toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'name': name,
      'days': days,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
    };
  }
}



