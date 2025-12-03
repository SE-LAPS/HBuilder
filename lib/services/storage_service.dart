import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload profile picture to Firebase Storage
  /// Returns the download URL
  Future<String?> uploadProfilePicture({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // Create a reference to the profile pictures location
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');

      // Upload the file
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('Profile picture uploaded: $downloadUrl');
      }

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile picture: $e');
      }
      rethrow;
    }
  }

  /// Delete profile picture from Firebase Storage
  Future<void> deleteProfilePicture({required String userId}) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      await ref.delete();

      if (kDebugMode) {
        print('Profile picture deleted for user: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting profile picture: $e');
      }
      rethrow;
    }
  }

  /// Get profile picture URL
  Future<String?> getProfilePictureUrl({required String userId}) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // File doesn't exist or other error
      if (kDebugMode) {
        print('Error getting profile picture URL: $e');
      }
      return null;
    }
  }

  /// Check file size (< 2MB)
  bool isFileSizeValid(File file) {
    final fileSize = file.lengthSync();
    const maxSize = 2 * 1024 * 1024; // 2MB in bytes
    return fileSize <= maxSize;
  }
}
