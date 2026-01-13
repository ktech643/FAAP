import 'package:faap/Views/Auth Screens/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../UI Helper/custom_message/custom_toast.dart';

class ForgotPasswordController {
  final WidgetRef ref;
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final BuildContext context;

  ForgotPasswordController(this.ref, this.context);

  String? validateEmail(String? value) {
    // Trim whitespace before validating
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return 'Email is required';
    }
    // Simpler, permissive regex that avoids rejecting many valid emails
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(v)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<bool> sendResetLink() async {
    // Prefer using the Form validator if the Form is wired up, otherwise use validateEmail
    final emailText = emailController.text.trim();

    final formState = formKey.currentState;
    if (formState != null) {
      if (!formState.validate()) {
        // If form validation failed, set error on provider for UI to consume
        final msg = validateEmail(emailText);
        if (msg != null) {
          ref.read(authProvider.notifier).setError(msg);
        }
        return false;
      }
    } else {
      final msg = validateEmail(emailText);
      if (msg != null) {
        // Set the error on provider so callers can read it
        ref.read(authProvider.notifier).setError(msg);
        return false;
      }
    }

    // Clear any previous error before calling provider
    ref.read(authProvider.notifier).clearError();

    final authNotifier = ref.read(authProvider.notifier);
    final success = await authNotifier.resetPassword(emailText);

    return success;
  }

  Future<bool> handleSendResetLink() async {
    // Clear previous provider error
    ref.read(authProvider.notifier).clearError();

    final emailText = emailController.text.trim();

    // Local quick validation and immediate feedback
    final validationMessage = validateEmail(emailText);
    if (validationMessage != null) {
      CustomToast.show(
        context: context,
        message: validationMessage,
        type: ToastType.error,
      );
      // Also set provider error so UI can display it
      ref.read(authProvider.notifier).setError(validationMessage);
      return false;
    }

    final success = await sendResetLink();

    if (success) {
      CustomToast.show(
        context: context,
        message: 'Reset link sent successfully! Please check your email.',
        type: ToastType.success,
      );
      return true;
    } else {
      final authState = ref.read(authProvider);
      final errorMsg =
          authState.error ?? 'Failed to send reset link. Please try again.';
      CustomToast.show(
        context: context,
        message: errorMsg,
        type: ToastType.error,
      );
      return false;
    }
  }

  void dispose() {
    emailController.dispose();
  }
}
