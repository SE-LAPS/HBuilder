class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? phone;
  final String? profilePictureUrl;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.phone,
    this.profilePictureUrl,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'],
      phone: map['phone'],
      profilePictureUrl: map['profilePictureUrl'],
      createdAt: map['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt,
    };
  }
}
