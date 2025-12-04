import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload profile picture to Firebase Storage
  /// Returns the download URL
  Future<String> uploadProfilePicture({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // Verify file exists
      if (!await imageFile.exists()) {
        if (kDebugMode) {
          print(
            '❌ Upload failed: Image file does not exist at ${imageFile.path}',
          );
        }
        throw Exception(
          'Image file does not exist. Please try selecting the image again.',
        );
      }

      // Check file size
      if (!isFileSizeValid(imageFile)) {
        final fileSize = (imageFile.lengthSync() / (1024 * 1024))
            .toStringAsFixed(2);
        if (kDebugMode) {
          print('❌ Upload failed: File size ${fileSize}MB exceeds 2MB limit');
        }
        throw Exception(
          'Image file size (${fileSize}MB) exceeds the 2MB limit. Please choose a smaller image.',
        );
      }

      if (kDebugMode) {
        print('🔄 Starting upload for user: $userId');
        print('   File path: ${imageFile.path}');
        print(
          '   File size: ${(imageFile.lengthSync() / 1024).toStringAsFixed(2)} KB',
        );
      }

      // Create a unique filename with timestamp to avoid caching issues
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child(
        'profile_pictures/${userId}_$timestamp.jpg',
      );

      if (kDebugMode) {
        print('   Storage ref: ${ref.fullPath}');
        print('   Bucket: ${ref.bucket}');
      }

      // Upload the file with metadata
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          cacheControl: 'public, max-age=300',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (kDebugMode) {
          final progress =
              (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          print(
            '📤 Upload progress: ${progress.toStringAsFixed(1)}% (${snapshot.bytesTransferred}/${snapshot.totalBytes} bytes)',
          );
        }
      });

      // Wait for upload to complete
      final snapshot = await uploadTask.whenComplete(() {});

      if (kDebugMode) {
        print('✅ Upload completed. Getting download URL...');
      }

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('✅ Profile picture uploaded successfully!');
        print('   Download URL: $downloadUrl');
      }

      return downloadUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase Storage Error:');
        print('   Code: ${e.code}');
        print('   Message: ${e.message}');
        print('   Details: ${e.plugin}');
      }

      // Handle specific Firebase errors
      switch (e.code) {
        case 'storage/object-not-found':
          throw Exception(
            'Storage bucket not found. Please ensure Firebase Storage is set up correctly in the Firebase Console.',
          );
        case 'storage/unauthorized':
          throw Exception(
            'Unauthorized access. Please check your Firebase Storage security rules.',
          );
        case 'storage/canceled':
          throw Exception('Upload was canceled. Please try again.');
        case 'storage/unknown':
          throw Exception(
            'An unknown error occurred. Please check your internet connection and try again.',
          );
        case 'storage/invalid-checksum':
          throw Exception(
            'Upload failed due to checksum error. Please try again.',
          );
        case 'storage/retry-limit-exceeded':
          throw Exception(
            'Upload failed after multiple retries. Please check your internet connection and try again.',
          );
        case 'storage/unauthenticated':
          throw Exception('You must be signed in to upload a profile picture.');
        case 'storage/quota-exceeded':
          throw Exception('Storage quota exceeded. Please contact support.');
        default:
          throw Exception('Failed to upload image: ${e.message ?? e.code}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading profile picture: $e');
        print('   Error type: ${e.runtimeType}');
      }

      // Re-throw if already an Exception
      if (e is Exception) {
        rethrow;
      }

      throw Exception('Failed to upload image: $e');
    }
  }

  /// Delete profile picture from Firebase Storage
  /// Takes the profilePictureUrl to delete the correct timestamped file
  Future<void> deleteProfilePicture({
    required String userId,
    String? profilePictureUrl,
  }) async {
    try {
      if (profilePictureUrl == null || profilePictureUrl.isEmpty) {
        if (kDebugMode) {
          print('⚠️ No profile picture URL provided, nothing to delete');
        }
        return;
      }

      if (kDebugMode) {
        print('🗑️ Deleting profile picture for user: $userId');
        print('   URL: $profilePictureUrl');
      }

      // Get reference from URL
      final ref = _storage.refFromURL(profilePictureUrl);
      await ref.delete();

      if (kDebugMode) {
        print('✅ Profile picture deleted successfully');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('❌ Firebase error deleting profile picture:');
        print('   Code: ${e.code}');
        print('   Message: ${e.message}');
      }

      // Don't throw error if file doesn't exist (already deleted)
      if (e.code == 'storage/object-not-found') {
        if (kDebugMode) {
          print('   File already deleted or doesn\'t exist');
        }
        return;
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting profile picture: $e');
        print('   Error type: ${e.runtimeType}');
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
