import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Provider/auth_provider.dart';

final signUpControllerProvider = Provider.autoDispose<SignUpController>((ref) {
  final controller = SignUpController(ref);
  ref.onDispose(() => controller.dispose());
  return controller;
});

class SignUpController {
  final Ref _ref;

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignUpController(this._ref);

  Future<bool> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validate form
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

    if (password != confirmPassword) {
      _ref.read(authProvider.notifier).setError('Passwords do not match');
      return false;
    }

    // Attempt signup and let the AuthProvider handle the error states
    await _ref.read(authProvider.notifier).signUp(email, password);

    // Check if there was an error after the signup attempt
    final error = _ref.read(authProvider).error;
    return error == null; // Return true if there was no error
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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
    confirmPasswordController.dispose();
  }

  // Getters for form values
  String get email => emailController.text.trim();
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;

  // Setters for form values
  set email(String value) => emailController.text = value;
  set password(String value) => passwordController.text = value;
  set confirmPassword(String value) => confirmPasswordController.text = value;
}
