import 'dart:io' show Platform;

import 'package:faap/UI Helper/Buttons/primary_button.dart';
import 'package:faap/UI Helper/custom_message/custom_toast.dart';
import 'package:faap/UI Helper/inputfields.dart';
import 'package:faap/UI%20Helper/Buttons/social_button.dart';
import 'package:faap/Views/Dashboard/Profile/webview_screen.dart';
import 'package:faap/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Provider/auth_provider.dart';
import '../OnBoarding/UI/onboarding_view.dart';
import '../Provider/universal_provider.dart';
import '../Signin/signinscreen.dart';
import 'signup_controller.dart';

class SignUpScreenView extends ConsumerWidget {
  const SignUpScreenView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpController = ref.watch(signUpControllerProvider);
    final authState = ref.watch(authProvider);
    final isSocialLoading = ref.watch(universalLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => navigatorKey.currentState?.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 28,
                        color: Color(0xFF0f172a), // secondary-900
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0f172a), // secondary-900
                        ),
                      ),
                    ),
                    SizedBox(width: 48.w), // To balance the back button
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      // Email input
                      PrimaryInputField(
                        controller: signUpController.emailController,
                        labelText: 'Email',
                        labelStyle: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF374151), // gray-700
                        ),
                        hintText: 'Enter your email',
                        enabledBorderColor: const Color(0xFFd1d5db),
                        focusBorderColor: const Color(0xFF22c55e),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16.h),
                      // Password input
                      PrimaryInputField(
                        controller: signUpController.passwordController,
                        labelText: 'Password',
                        labelStyle: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF374151), // gray-700
                        ),
                        hintText: 'Enter your password',
                        enabledBorderColor: const Color(0xFFd1d5db),
                        focusBorderColor: const Color(0xFF22c55e),
                        isPassword: true,
                      ),
                      SizedBox(height: 16.h),
                      // Confirm Password input
                      PrimaryInputField(
                        controller: signUpController.confirmPasswordController,
                        labelText: 'Confirm Password',
                        labelStyle: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF374151), // gray-700
                        ),
                        hintText: 'Confirm your password',
                        enabledBorderColor: const Color(0xFFd1d5db),
                        focusBorderColor: const Color(0xFF22c55e),
                        isPassword: true,
                      ),
                      SizedBox(height: 16.h),
                      // Terms and Privacy notice
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: const Color(0xFF6b7280), // gray-500
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF22c55e), // primary
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (
                                                  context,
                                                ) => const WebViewScreen(
                                                  title: 'Terms & Conditions',
                                                  url:
                                                      'http://faapscan.chassinc.org/terms.html',
                                                ),
                                          ),
                                        );
                                      },
                              ),
                              TextSpan(
                                text: ' and ',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF6b7280),
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF22c55e), // primary
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (
                                                  context,
                                                ) => const WebViewScreen(
                                                  title: 'Privacy Policy',
                                                  url:
                                                      'http://faapscan.chassinc.org/privacy.html',
                                                ),
                                          ),
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Sign Up button
                      PrimaryButton(
                        text: 'Sign Up',
                        onPressed:
                            authState.isLoading
                                ? null
                                : () async {
                                  // Clear any previous errors
                                  ref.read(authProvider.notifier).clearError();

                                  final success =
                                      await signUpController.signUp();

                                  // Get the latest state after signup attempt
                                  final currentState = ref.read(authProvider);

                                  if (success &&
                                      currentState.error == null &&
                                      context.mounted) {
                                    // Show success toast
                                    Toast.success(
                                      context: context,
                                      message: 'Account created successfully!',
                                    );
                                    // Navigate to sign in screen after a short delay
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        if (context.mounted) {
                                          navigatorKey.currentState!
                                              .pushReplacement(
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          const SignInScreenView(),
                                                ),
                                              );
                                        }
                                      },
                                    );
                                  } else if (context.mounted) {
                                    // Show error toast with the actual error message
                                    Toast.error(
                                      context: context,
                                      message:
                                          currentState.error ??
                                          'Please try again.',
                                    );
                                  }
                                },
                        isLoading: authState.isLoading,
                      ),
                      // Error message
                      if (authState.error != null)
                        Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: Text(
                            authState.error!,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(height: 24.h),
                      // Divider
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: Color(0xFFd1d5db)),
                          ), // gray-300
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'Or',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: const Color(0xFF6b7280), // gray-500
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: Color(0xFFd1d5db)),
                          ), // gray-300
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Platform-specific social button
                      Row(
                        children: [
                          if (Platform.isAndroid)
                            SocialButton(
                              type: SocialButtonType.google,
                              isLoading: authState.isGoogleLoading,
                              onPressed: () async {
                                final success =
                                    await signUpController.signUpWithGoogle();
                                if (success && context.mounted) {
                                  Toast.success(
                                    context: context,
                                    message: 'Signed up successfully',
                                  );
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      if (context.mounted) {
                                        navigatorKey.currentState!
                                            .pushReplacement(
                                              MaterialPageRoute(
                                                builder:
                                                    (_) =>
                                                        const OnBoardingView(),
                                              ),
                                            );
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          if (Platform.isIOS)
                            SocialButton(
                              type: SocialButtonType.apple,
                              isLoading: authState.isAppleLoading,
                              onPressed: () async {
                                final success =
                                    await signUpController.signUpWithApple();
                                if (success && context.mounted) {
                                  Toast.success(
                                    context: context,
                                    message: 'Signed up successfully',
                                  );
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      if (context.mounted) {
                                        navigatorKey.currentState!
                                            .pushReplacement(
                                              MaterialPageRoute(
                                                builder:
                                                    (_) =>
                                                        const OnBoardingView(),
                                              ),
                                            );
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Footer
              Padding(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF6b7280), // gray-500
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF16a34a), // primary-600
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  navigatorKey.currentState!.pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const SignInScreenView(),
                                    ),
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
