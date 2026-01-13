import 'package:faap/UI Helper/inputfields.dart';
import 'package:faap/UI%20Helper/Buttons/primary_button.dart';
import 'package:faap/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Provider/auth_provider.dart';
import '../Signin/signinscreen.dart';
import 'forgotcontroller.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  late final ForgotPasswordController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ForgotPasswordController(ref, context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Form(
            key: _controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => navigatorKey.currentState?.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 28,
                          color: Color(0xFF374151), // gray-700
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Back',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF374151), // gray-700
                        ),
                      ),
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
                        // Title
                        Text(
                          'Forgot Password?',
                          style: GoogleFonts.inter(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF111827), // gray-900
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Subtitle
                        Text(
                          "No worries, we'll send you reset instructions.",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: const Color(0xFF6b7280), // gray-500
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Email input
                        PrimaryInputField(
                          controller: _controller.emailController,
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
                          prefixIcon: const Icon(
                            Icons.mail,
                            color: Color(0xFF6b7280), // gray-500
                          ),
                          validator: _controller.validateEmail,
                        ),
                        SizedBox(height: 24.h),
                        // Send Reset Link button
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            text: 'Send Reset Link',
                            onPressed:
                                authState.isLoading
                                    ? null
                                    : _controller.handleSendResetLink,
                            width: double.infinity,
                            isLoading: authState.isLoading,
                          ),
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
                        text: "Remembered your password? ",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF6b7280), // gray-500
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF16a34a), // primary-600
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    navigatorKey.currentState!.pushReplacement(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const SignInScreenView(),
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
      ),
    );
  }
}
