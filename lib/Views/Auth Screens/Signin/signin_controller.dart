import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Provider/auth_provider.dart';

final signInControllerProvider = Provider.autoDispose<SignInController>((ref) {
  final controller = SignInController(ref);
  ref.onDispose(() => controller.dispose());
  return controller;
});

class SignInController {
  final Ref _ref;

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  SignInController(this._ref);

  Future<bool> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Clear any previous errors before attempting sign in
    _ref.read(authProvider.notifier).clearError();

    // Validate input
    if (!isValidEmail(email)) {
      _ref
          .read(authProvider.notifier)
          .setError('Please enter a valid email address');
      return false;
    }

    if (!isValidPassword(password)) {
      _ref
          .read(authProvider.notifier)
          .setError('Password must be at least 6 characters long');
      return false;
    }

    // Attempt sign in
    return await _ref.read(authProvider.notifier).signIn(email, password);
  }

  /// Sign in using Google. Returns true on success.
  Future<bool> signInWithGoogle() async {
    // Clear previous errors
    _ref.read(authProvider.notifier).clearError();
    return await _ref.read(authProvider.notifier).signInWithGoogle();
  }

  /// Sign in using Apple ID. Returns true on success.
  Future<bool> signInWithApple() async {
    // Clear previous errors
    _ref.read(authProvider.notifier).clearError();
    return await _ref.read(authProvider.notifier).signInWithApple();
  }

  bool isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  String? getError() {
    return _ref.read(authProvider).error;
  }

  bool get isLoading {
    return _ref.read(authProvider).isLoading;
  }

  void clearError() {
    _ref.read(authProvider.notifier).clearError();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  // Getters for form values
  String get email => emailController.text.trim();
  String get password => passwordController.text;

  // Setters for form values
  set email(String value) => emailController.text = value;
  set password(String value) => passwordController.text = value;
}
