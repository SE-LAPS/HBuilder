import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<void> checkAuthStatus() async {
    _user = _auth.currentUser;
    if (_user != null) {
      await _loadUserData();
    }
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        _userModel = UserModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user;
      await _loadUserData();
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage =
          'Firebase not configured. Please run: flutterfire configure';
      print('General Error during sign in: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(
    String email,
    String password,
    String name,
    String? phone,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user;

      // Create user document
      final userModel = UserModel(
        uid: _user!.uid,
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .set(userModel.toMap());
      _userModel = userModel;

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error saving user data: ${e.toString()}';
      print('General Error during signup: $e');
      print('Error type: ${e.runtimeType}');
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      if (_user != null) {
        // Check if user document exists
        final doc = await _firestore.collection('users').doc(_user!.uid).get();

        if (!doc.exists) {
          // Create new user document for first-time Google sign-in
          final userModel = UserModel(
            uid: _user!.uid,
            email: _user!.email ?? '',
            name: _user!.displayName ?? googleUser.displayName,
            phone: null,
            profilePictureUrl: _user!.photoURL,
            createdAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(_user!.uid)
              .set(userModel.toMap());
          _userModel = userModel;
        } else {
          // Load existing user data
          await _loadUserData();
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An error occurred during Google Sign-In';
      print('Google Sign-In Error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  /// Update user profile picture URL
  void updateProfilePicture(String? url) {
    if (_userModel != null) {
      _userModel = UserModel(
        uid: _userModel!.uid,
        email: _userModel!.email,
        name: _userModel!.name,
        phone: _userModel!.phone,
        profilePictureUrl: url,
        createdAt: _userModel!.createdAt,
      );
      notifyListeners();
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
