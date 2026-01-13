import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../Models/user_model.dart';
import '../../../supabase_config.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final User? user;
  final UserModel? userData;
  final bool isLoading;
  final bool isGoogleLoading;
  final bool isAppleLoading;
  final String? error;

  const AuthState({
    this.user,
    this.userData,
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    UserModel? userData,
    bool? isLoading,
    bool? isGoogleLoading,
    bool? isAppleLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      isAppleLoading: isAppleLoading ?? this.isAppleLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseClient _supabase = SupabaseConfig.client;

  final GoogleSignIn _googleSignInInstance = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        "1021262745107-p7ui0rohkehjqtf2t6ufh7m5hceusue5.apps.googleusercontent.com",
  );

  AuthNotifier() : super(const AuthState()) {
    _supabase.auth.onAuthStateChange.listen((data) async {
      final user = data.session?.user;
      if (user != null) {
        final userData = await _fetchUserData(user.id);
        state = state.copyWith(user: user, userData: userData);
      } else {
        state = state.copyWith(user: null, userData: null);
      }
    });
  }

  Future<UserModel?> _fetchUserData(String uid) async {
    try {
      final response =
          await _supabase.from('profile').select().eq('id', uid).single();

      return UserModel(
        uid: response['id'] as String,
        email: response['email'] as String,
        fullName: response['full_name'] as String?,
        phoneNo: response['phone_no'] as int?,
      );
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  /// Create a new profile for the user in the profile table
  Future<void> createProfile(
    User user, {
    String? fullName,
    String? phoneNo,
  }) async {
    try {
      await _supabase.from('profile').insert({
        'id': user.id,
        'email': user.email,
        'full_name': fullName,
        'phone_no': phoneNo,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("Error creating profile: $e");
      throw e;
    }
  }

  /// Returns true if a user is currently signed in.
  bool get isUserSignedIn {
    return _supabase.auth.currentUser != null;
  }

  /// Checks if a user is signed in, updates state with user if true, and returns status.
  /// Also fetches the user profile data from the database.
  Future<bool> checkAndSaveUserSignedIn() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser != null) {
      // Fetch user profile data when user is already logged in
      final userData = await _fetchUserData(currentUser.id);
      state = state.copyWith(user: currentUser, userData: userData);
      return true;
    } else {
      state = state.copyWith(user: null, userData: null);
      return false;
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Create profile in Supabase database
        await createProfile(
          response.user!,
          fullName: response.user?.userMetadata?['full_name'],
        );

        // Fetch and update state with the new user data
        final userData = await _fetchUserData(response.user!.id);
        state = state.copyWith(
          user: response.user,
          userData: userData,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to create account',
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e.message),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = const AuthState(isLoading: true);
    bool status = false;

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userData = await _fetchUserData(response.user!.id);
        if (userData == null) {
          // If profile doesn't exist in database, create it
          await createProfile(
            response.user!,
            fullName: response.user?.userMetadata?['full_name'],
          );
          // Fetch the newly created data
          final newUserData = await _fetchUserData(response.user!.id);
          state = AuthState(
            user: response.user,
            userData: newUserData,
            isLoading: false,
          );
        } else {
          state = AuthState(
            user: response.user,
            userData: userData,
            isLoading: false,
          );
        }
        status = true;
      } else {
        state = AuthState(isLoading: false, error: 'Failed to sign in');
        status = false;
      }
    } on AuthException catch (e) {
      state = AuthState(isLoading: false, error: _getErrorMessage(e.message));
      status = false;
    } catch (e) {
      state = AuthState(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
      status = false;
    }
    return status;
  }

  Future<void> saveUserInfo({
    required String uid,
    required String email,
    String? fullName,
    String? phoneNo,
  }) async {
    try {
      final userModel = UserModel(
        uid: uid,
        email: email,
        fullName: fullName,
        phoneNo: int.tryParse(phoneNo ?? ''),
      );

      // Upsert into profile table using 'id' instead of 'uid'
      await _supabase.from('profile').upsert({
        'id': uid,
        'email': email,
        'username': email.split('@')[0],
        'full_name': fullName,
        'phone_no': phoneNo,
      });

      // Update state with the new user data
      state = state.copyWith(userData: userModel);
    } catch (e) {
      print("ERROR SAVING USER INFO: $e");
      state = state.copyWith(error: 'Failed to save user info');
    }
  }

  /// Sign in using Google account via GoogleSignIn and Supabase credential.
  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isGoogleLoading: true, error: null);
    try {
      // Sign out first to ensure clean state
      await _googleSignInInstance.signOut();

      // Initiate Google Sign-In
      final GoogleSignInAccount? googleUser =
          await _googleSignInInstance.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        state = state.copyWith(isGoogleLoading: false);
        return false;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if we have the ID token
      if (googleAuth.idToken == null) {
        state = state.copyWith(
          isGoogleLoading: false,
          error:
              'Failed to get Google ID token. Please check your Google Sign-In configuration.',
        );
        return false;
      }

      // Sign in to Supabase with the Google ID token
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
      );

      if (response.user != null) {
        final user = response.user!;

        // Check if profile exists in database
        final userData = await _fetchUserData(user.id);
        if (userData == null) {
          // Create new profile if it doesn't exist
          await createProfile(
            user,
            fullName: user.userMetadata?['full_name'] ?? googleUser.displayName,
          );
        }

        // Fetch final user data
        final finalUserData = await _fetchUserData(user.id);
        state = AuthState(
          user: user,
          userData: finalUserData,
          isGoogleLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isGoogleLoading: false,
          error: 'Failed to sign in with Google',
        );
        return false;
      }
    } on PlatformException catch (e) {
      await _googleSignInInstance.signOut();

      String errorMessage = 'Failed to sign in with Google';
      if (e.code == 'sign_in_failed') {
        if (e.message?.contains('10') ?? false) {
          errorMessage =
              'Google Sign-In configuration error. Please ensure Android OAuth client is properly set up.';
        }
      }

      state = state.copyWith(isGoogleLoading: false, error: errorMessage);
      return false;
    } catch (e) {
      await _googleSignInInstance.signOut();
      state = state.copyWith(
        isGoogleLoading: false,
        error: 'Failed to sign in with Google: ${e.toString()}',
      );
      return false;
    }
  }

  /// Sign in using Apple ID (iOS). Uses a secure raw nonce and hashed nonce for Apple.
  Future<bool> signInWithApple() async {
    final bool available = await SignInWithApple.isAvailable();
    if (!available) {
      state = state.copyWith(
        error: 'Apple Sign-In is not available on this platform',
      );
      return false;
    }

    state = state.copyWith(isAppleLoading: true, error: null);

    // Helper: generate a secure random nonce
    String _generateNonce([int length = 32]) {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final rand = Random.secure();
      return List.generate(length, (_) => charset[rand.nextInt(charset.length)])
          .join();
    }

    try {
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      if (appleCredential.identityToken == null) {
        state = state.copyWith(
          isAppleLoading: false,
          error: 'Failed to get Apple ID token',
        );
        return false;
      }

      // Sign in to Supabase with the Apple ID token and raw nonce
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: appleCredential.identityToken!,
        nonce: rawNonce,
      );

      if (response.user != null) {
        final user = response.user!;

        // If Apple provided name parts, save them to user metadata
        if (appleCredential.givenName != null ||
            appleCredential.familyName != null) {
          final nameParts = <String>[];
          if (appleCredential.givenName != null) {
            nameParts.add(appleCredential.givenName!);
          }
          if (appleCredential.familyName != null) {
            nameParts.add(appleCredential.familyName!);
          }
          final fullName = nameParts.join(' ');

          try {
            await _supabase.auth.updateUser(
              UserAttributes(
                data: {
                  'full_name': fullName,
                  'given_name': appleCredential.givenName,
                  'family_name': appleCredential.familyName,
                },
              ),
            );
          } catch (e) {
            // Non-fatal: continue even if metadata update fails
            print('Failed to update user metadata: $e');
          }
        }

        // Ensure profile exists in DB
        final userData = await _fetchUserData(user.id);
        if (userData == null) {
          String? fullNameFromCred;
          if (appleCredential.givenName != null ||
              appleCredential.familyName != null) {
            fullNameFromCred = [
              appleCredential.givenName,
              appleCredential.familyName
            ].where((n) => n != null).join(' ');
          }

          await createProfile(
            user,
            fullName: fullNameFromCred ?? user.userMetadata?['full_name'],
          );
        }

        final finalUserData = await _fetchUserData(user.id);
        state = AuthState(
          user: user,
          userData: finalUserData,
          isAppleLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isAppleLoading: false,
          error: 'Failed to sign in with Apple',
        );
        return false;
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        isAppleLoading: false,
        error: _getErrorMessage(e.message),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isAppleLoading: false,
        error: 'Failed to sign in with Apple: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _supabase.auth.signOut();
      state = const AuthState(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to sign out. Please try again.',
      );
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    if (email.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please enter your email address.',
      );
      return false;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      state = state.copyWith(isLoading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getErrorMessage(e.message),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to send reset email. Please try again.',
      );
      return false;
    }
  }

  Future<void> editUserInfo(UserModel userModel) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Update Supabase user metadata
      if (userModel.fullName != null) {
        await _supabase.auth.updateUser(
          UserAttributes(data: {'full_name': userModel.fullName}),
        );
      }

      // Update profile in database
      await _supabase
          .from('profile')
          .update({
            // 'email': userModel.email,
            // 'username': userModel.email.split('@')[0],
            'full_name': userModel.fullName,
            'phone_no': userModel.phoneNo,
          })
          .eq('id', user.id);

      // Update local state with new user data
      state = state.copyWith(userData: userModel);
    } catch (e) {
      print('Error updating user info: $e');
      throw e;
    }
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.copyWith(error: null, isLoading: false);
  }

  Future<bool> deleteAccount() async {
    state = state.copyWith(isLoading: true, error: null);
    final user = _supabase.auth.currentUser;

    if (user == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'No user found. Please sign in again.',
      );
      return false;
    }

    try {
      final userId = user.id;

      // Delete all user's products
      try {
        await _supabase.from('products').delete().eq('owner', userId);
      } catch (e) {
        print('Error deleting products: $e');
        // Continue even if products deletion fails
      }

      // Delete user's profile
      try {
        await _supabase.from('profile').delete().eq('id', userId);
      } catch (e) {
        print('Error deleting profile: $e');
        // Continue even if profile deletion fails
      }
      //TODO RESOLVE THIS LATER
      //Not DEleteing auth user as it requires service role key which should not be used in client apps

      // // Delete user from Supabase Authentication
      // try {
      //   await _supabase.auth.admin.deleteUser(userId);
      // } catch (e) {
      //   print('Error deleting auth user: $e');
      //   // If this fails, still sign out the user
      // }

      // Sign out the user
      await _supabase.auth.signOut();

      // Sign out from Google if signed in with Google
      try {
        await _googleSignInInstance.signOut();
      } catch (e) {
        print('Error signing out from Google: $e');
        // Continue even if Google sign out fails
      }

      state = const AuthState(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete account. Please try again.',
      );
      return false;
    }
  }

  String _getErrorMessage(String? errorMessage) {
    // Return backend message directly (fallback to a generic message if null)
    return errorMessage ?? 'An unexpected error occurred';
  }
}
