import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_center_model.dart';
import '../models/vehicle_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Service Centers
  Stream<List<ServiceCenterModel>> getServiceCenters() {
    return _firestore
        .collection('serviceCenters')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceCenterModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<ServiceCenterModel?> getServiceCenter(String id) async {
    try {
      final doc = await _firestore.collection('serviceCenters').doc(id).get();
      if (doc.exists) {
        return ServiceCenterModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Vehicles
  Stream<List<VehicleModel>> getUserVehicles(String userId) {
    return _firestore
        .collection('vehicles')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VehicleModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    await _firestore.collection('vehicles').add(vehicle.toMap());
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await _firestore.collection('vehicles').doc(vehicleId).delete();
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    await _firestore.collection('vehicles').doc(vehicle.id).update(vehicle.toMap());
  }

  // Franchise Application
  Future<void> submitFranchiseApplication({
    required String name,
    required String contactNumber,
    required String franchiseCity,
    required String message,
    required String userId,
  }) async {
    await _firestore.collection('franchiseApplications').add({
      'name': name,
      'contactNumber': contactNumber,
      'franchiseCity': franchiseCity,
      'message': message,
      'userId': userId,
      'status': 'pending',
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }

  // Purchase History
  Future<void> addPurchaseHistory({
    required String userId,
    required String serviceCenterId,
    required String cardType,
    required double amount,
  }) async {
    await _firestore.collection('purchaseHistory').add({
      'userId': userId,
      'serviceCenterId': serviceCenterId,
      'cardType': cardType,
      'amount': amount,
      'purchasedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getPurchaseHistory(String userId) {
    return _firestore
        .collection('purchaseHistory')
        .where('userId', isEqualTo: userId)
        .orderBy('purchasedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }
}



