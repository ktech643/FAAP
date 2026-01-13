import 'package:faap/UI Helper/Buttons/primary_button.dart';
import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:faap/UI Helper/inputfields.dart';
import 'package:faap/UI%20Helper/custom_message/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Auth Screens/Provider/auth_provider.dart';
import '../../../Auth Screens/Provider/universal_provider.dart';
import 'profile_edit_controller.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: 'Edit Profile', transparent: false),
      body: const ProfileEditForm(),
    );
  }
}

class ProfileEditForm extends ConsumerStatefulWidget {
  const ProfileEditForm({super.key});

  @override
  ConsumerState<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends ConsumerState<ProfileEditForm> {
  late final ProfileEditController controller;

  @override
  void initState() {
    super.initState();
    controller = ProfileEditController(ref);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(authProvider.select((state) => state.userData));
    final email = userData?.email ?? '';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              // Full Name input
              PrimaryInputField(
                labelText: 'Full Name',
                labelStyle: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person, color: AppColors.secondary),
                enabledBorderColor: AppColors.border,
                focusBorderColor: AppColors.primary,
                controller: controller.nameController,
              ),
              SizedBox(height: 16.h),
              // Email input (read-only)
              PrimaryInputField(
                labelText: 'Email',
                labelStyle: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email, color: AppColors.secondary),
                enabledBorderColor: AppColors.border,
                focusBorderColor: AppColors.primary,
                initialValue: email,
                ReadOnly: true,
              ),
              SizedBox(height: 16.h),
              // Phone input
              PrimaryInputField(
                labelText: 'Phone Number',
                labelStyle: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                keyboardType: TextInputType.phone,
                hintText: 'Enter your phone number',
                prefixIcon: Icon(Icons.phone, color: AppColors.secondary),
                enabledBorderColor: AppColors.border,
                focusBorderColor: AppColors.primary,
                controller: controller.phoneController,
              ),
              SizedBox(height: 32.h),
              _SaveButton(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  final ProfileEditController controller;

  const _SaveButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(universalLoadingProvider);

    return PrimaryButton(
      text: 'Save',
      isLoading: isLoading,
      onPressed: () async {
        bool success = await controller.updateUserProfile();
        if (success && context.mounted) {
          Toast.success(
            context: context,
            message: 'Profile updated successfully',
          );
        } else if (context.mounted) {
          Toast.error(context: context, message: 'Failed to update profile');
        }
      },
    );
  }
}
