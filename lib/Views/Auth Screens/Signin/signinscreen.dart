import 'dart:io' show Platform;

import 'package:faap/UI Helper/Buttons/primary_button.dart';
import 'package:faap/UI Helper/inputfields.dart';
import 'package:faap/UI%20Helper/Buttons/social_button.dart';
import 'package:faap/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../UI Helper/custom_message/custom_toast.dart';
import '../ForgotPassword/forgotpassword.dart';
import '../OnBoarding/UI/onboarding_view.dart';
import '../Provider/auth_provider.dart';
import '../Provider/universal_provider.dart';
import '../Signup/signupscreen.dart';
import 'signin_controller.dart';

class SignInScreenView extends ConsumerWidget {
  const SignInScreenView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(signInControllerProvider);
    final authState = ref.watch(authProvider);
    ref.watch(universalLoadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                    Expanded(
                      child: Center(
                        child: Text(
                          'Sign In',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0f172a), // secondary-900
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(width: 48.w), // To balance the back button
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
                        hintText: 'Email or Username',
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Color(0xFF64748b),
                        ),
                        enabledBorderColor: const Color(0xFFe2e8f0),
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: controller.emailFocusNode,
                        nextFocusNode: controller.passwordFocusNode,
                        nextOrDone: true,
                      ),
                      SizedBox(height: 16.h),
                      // Password input
                      PrimaryInputField(
                        hintText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF64748b),
                        ),
                        enabledBorderColor: const Color(0xFFe2e8f0),
                        isPassword: true,
                        controller: controller.passwordController,
                        focusNode: controller.passwordFocusNode,
                        onFieldSubmitted: (_) async {
                          // Prevent duplicate attempts if already loading
                          if (authState.isLoading) return;
                          final success = await controller.signIn();
                          if (success && context.mounted) {
                            // Show success toast
                            Toast.success(
                              context: context,
                              message: 'Signed in successfully',
                            );
                            // Navigate to onboarding screen after a short delay
                            Future.delayed(const Duration(seconds: 1), () {
                              if (context.mounted) {
                                navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const OnBoardingView(),
                                  ),
                                );
                              }
                            });
                          }
                        },
                      ),
                      SizedBox(height: 16.h),
                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            navigatorKey.currentState!.push(
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordView(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF16a34a), // primary-600
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Log In button
                      PrimaryButton(
                        text: authState.isLoading ? 'Signing In...' : 'Log In',
                        onPressed:
                            authState.isLoading
                                ? null
                                : () async {
                                  final success = await controller.signIn();
                                  if (success && context.mounted) {
                                    // Show success toast
                                    Toast.success(
                                      context: context,
                                      message: 'Signed in successfully',
                                    );
                                    // Navigate to onboarding screen after a short delay
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
                        isLoading: authState.isLoading,
                      ),
                      SizedBox(height: 24.h),
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
                      SizedBox(height: 10.h),
                      // Divider
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: Color(0xFFe2e8f0)),
                          ), // secondary-200
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'or continue with',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: const Color(0xFF64748b), // secondary-500
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: Color(0xFFe2e8f0)),
                          ), // secondary-200
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Social buttons
                      Row(
                        children: [
                          if (Platform.isAndroid)
                            SocialButton(
                              type: SocialButtonType.google,
                              isLoading: authState.isGoogleLoading,
                              onPressed: () async {
                                final success =
                                    await controller.signInWithGoogle();
                                if (success && context.mounted) {
                                  Toast.success(
                                    context: context,
                                    message: 'Signed in successfully',
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
                                    await controller.signInWithApple();
                                if (success && context.mounted) {
                                  Toast.success(
                                    context: context,
                                    message: 'Signed in successfully',
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
                      text: "Don't have an account? ",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF475569), // secondary-600
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF16a34a), // primary-600
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  navigatorKey.currentState!.push(
                                    MaterialPageRoute(
                                      builder: (_) => const SignUpScreenView(),
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
