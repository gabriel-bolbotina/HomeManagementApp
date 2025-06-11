import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/FirebaseService.dart';
import '../model/app_user.dart';

part 'auth_provider.g.dart';

class AuthState {
  final User? user;
  final AppUser? userProfile;
  final bool isLoading;
  final String? error;
  final bool isSignedIn;

  const AuthState({
    this.user,
    this.userProfile,
    this.isLoading = false,
    this.error,
    this.isSignedIn = false,
  });

  AuthState copyWith({
    User? user,
    AppUser? userProfile,
    bool? isLoading,
    String? error,
    bool? isSignedIn,
  }) {
    return AuthState(
      user: user ?? this.user,
      userProfile: userProfile ?? this.userProfile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSignedIn: isSignedIn ?? this.isSignedIn,
    );
  }
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  AuthState build() {
    // Check if there's already a current user
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Start loading user profile
      _fetchUserProfileAndUpdate(currentUser.uid);
      return AuthState(
        user: currentUser,
        isSignedIn: true,
        isLoading: true,
      );
    }
    
    _listenToAuthChanges();
    return const AuthState(isSignedIn: false, isLoading: false);
  }
  
  void _fetchUserProfileAndUpdate(String uid) async {
    try {
      final userProfile = await _fetchUserProfile(uid);
      state = state.copyWith(
        userProfile: userProfile,
        isLoading: false,
      );
    } catch (e) {
      developer.log('Error fetching user profile during initialization',
          name: 'AuthNotifier', error: e, level: 1000);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load user profile',
      );
    }
  }

  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) async {
      developer.log('Auth state changed: ${user?.uid}', name: 'AuthNotifier');

      if (user != null) {
        try {
          final userProfile = await _fetchUserProfile(user.uid);
          developer.log('User profile loaded: ${userProfile?.toFirestore()}', name: 'AuthNotifier');
          state = AuthState(
            user: user,
            userProfile: userProfile,
            isSignedIn: true,
            isLoading: false,
          );
        } catch (e) {
          developer.log('Error fetching user profile',
              name: 'AuthNotifier', error: e, level: 1000);
          state = AuthState(
            user: user,
            isSignedIn: true,
            isLoading: false,
            error: 'Failed to load user profile',
          );
        }
      } else {
        developer.log('User signed out', name: 'AuthNotifier');
        state = const AuthState(isSignedIn: false, isLoading: false);
      }
    });
  }

  Future<AppUser?> _fetchUserProfile(String uid) async {
    try {
      developer.log('Fetching user profile for uid: $uid',
          name: 'AuthNotifier');

      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      developer.log('Error in _fetchUserProfile',
          name: 'AuthNotifier', error: e, level: 1000);
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      developer.log('Signing in with email/password', name: 'AuthNotifier');

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      developer.log('Sign in successful: ${credential.user?.uid}',
          name: 'AuthNotifier');
    } on FirebaseAuthException catch (e) {
      developer.log('Firebase Auth Exception during sign in',
          name: 'AuthNotifier', error: e, level: 1000);

      String errorMessage = _getAuthErrorMessage(e.code);
      state = state.copyWith(isLoading: false, error: errorMessage);
      rethrow;
    } catch (e) {
      developer.log('Unexpected error during sign in',
          name: 'AuthNotifier', error: e, level: 1000);
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred. Please try again.',
      );
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      developer.log('Starting Google Sign In', name: 'AuthNotifier');

      final firebaseService = FirebaseService();
      await firebaseService.signInwithGoogle();

      developer.log('Google Sign In successful', name: 'AuthNotifier');
    } catch (e) {
      developer.log('Google Sign In failed',
          name: 'AuthNotifier', error: e, level: 1000);

      String errorMessage = 'Google Sign In failed. Please try again.';
      if (e is FirebaseAuthException) {
        errorMessage = _getAuthErrorMessage(e.code);
      }

      state = state.copyWith(isLoading: false, error: errorMessage);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      developer.log('Signing out', name: 'AuthNotifier');
      await _auth.signOut();
    } catch (e) {
      developer.log('Error signing out',
          name: 'AuthNotifier', error: e, level: 1000);
      rethrow;
    }
  }

  Future<void> createUserProfile({
    required String uid,
    String? firstName,
    String? lastName,
  }) async {
    try {
      developer.log('Creating user profile for uid: $uid',
          name: 'AuthNotifier');

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'first name': firstName ?? '',
        'last name': lastName ?? '',
        'age': null,
        'address': '',
        'zip code': '',
        'uploadedImage': '',
      });

      developer.log('User profile created successfully', name: 'AuthNotifier');

      // Refresh user profile
      final userProfile = await _fetchUserProfile(uid);
      state = state.copyWith(userProfile: userProfile);
    } catch (e) {
      developer.log('Failed to create user profile',
          name: 'AuthNotifier', error: e, level: 1000);
      rethrow;
    }
  }

  Future<void> updateUserProfile(AppUser updatedUser) async {
    try {
      developer.log('Updating user profile for uid: ${updatedUser.uid}',
          name: 'AuthNotifier');

      await _firestore.collection('users').doc(updatedUser.uid).update(
            updatedUser.toFirestore(),
          );

      state = state.copyWith(userProfile: updatedUser);
      developer.log('User profile updated successfully', name: 'AuthNotifier');
    } catch (e) {
      developer.log('Failed to update user profile',
          name: 'AuthNotifier', error: e, level: 1000);
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

// Convenience providers
@riverpod
User? currentUser(Ref ref) {
  return ref.watch(authNotifierProvider).user;
}

@riverpod
AppUser? currentUserProfile(Ref ref) {
  return ref.watch(authNotifierProvider).userProfile;
}

@riverpod
bool isSignedIn(Ref ref) {
  return ref.watch(authNotifierProvider).isSignedIn;
}

@riverpod
bool isLoading(Ref ref) {
  return ref.watch(authNotifierProvider).isLoading;
}

@riverpod
String? authError(Ref ref) {
  return ref.watch(authNotifierProvider).error;
}
