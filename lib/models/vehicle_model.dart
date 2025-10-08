class VehicleModel {
  final String id;
  final String userId;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleType;
  final String? brand;
  final String? model;
  final String? color;
  final DateTime? addedAt;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleType,
    this.brand,
    this.model,
    this.color,
    this.addedAt,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map, String id) {
    return VehicleModel(
      id: id,
      userId: map['userId'] ?? '',
      vehicleName: map['vehicleName'] ?? '',
      vehicleNumber: map['vehicleNumber'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      brand: map['brand'],
      model: map['model'],
      color: map['color'],
      addedAt: map['addedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'brand': brand,
      'model': model,
      'color': color,
      'addedAt': addedAt,
    };
  }
}



