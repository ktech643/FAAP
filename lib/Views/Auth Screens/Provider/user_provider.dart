import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../supabase_config.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

class UserData {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  const UserData({
    this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
    this.creationTime,
    this.lastSignInTime,
  });

  factory UserData.fromSupabaseUser(User? user) {
    if (user == null) {
      return const UserData();
    }

    return UserData(
      uid: user.id,
      email: user.email,
      displayName: user.userMetadata?['full_name'],
      photoUrl: user.userMetadata?['avatar_url'],
      isEmailVerified: user.emailConfirmedAt != null,
      creationTime: user.createdAt != null ? DateTime.parse(user.createdAt!) : null,
      lastSignInTime: user.lastSignInAt != null ? DateTime.parse(user.lastSignInAt!) : null,
    );
  }

  UserData copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isEmailVerified,
    DateTime? creationTime,
    DateTime? lastSignInTime,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
    );
  }
}

class UserState {
  final UserData userData;
  final bool isLoading;
  final String? error;

  const UserState({
    this.userData = const UserData(),
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({UserData? userData, bool? isLoading, String? error}) {
    return UserState(
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final SupabaseClient _supabase = SupabaseConfig.client;

  UserNotifier() : super(const UserState()) {
    _init();
  }

  void _init() {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser != null) {
      state = state.copyWith(userData: UserData.fromSupabaseUser(currentUser));
    }

    // Listen to auth state changes
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      state = state.copyWith(userData: UserData.fromSupabaseUser(user));
    });
  }

  Future<void> updateDisplayName(String displayName) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {'full_name': displayName},
        ),
      );
      state = state.copyWith(
        isLoading: false,
        userData: state.userData.copyWith(displayName: displayName),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update display name',
      );
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      // Supabase automatically sends verification email on signup
      // To resend, we need to call the resend method
      final email = _supabase.auth.currentUser?.email;
      if (email != null) {
        await _supabase.auth.resend(
          type: OtpType.signup,
          email: email,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to send verification email');
    }
  }

  Future<void> reloadUser() async {
    try {
      // Refresh the session to get latest user data
      await _supabase.auth.refreshSession();
      final updatedUser = _supabase.auth.currentUser;
      state = state.copyWith(userData: UserData.fromSupabaseUser(updatedUser));
    } catch (e) {
      state = state.copyWith(error: 'Failed to reload user data');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
