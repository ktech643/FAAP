import 'package:faap/Views/Auth Screens/Signin/signinscreen.dart';
import 'package:faap/Views/Dashboard/Profile/Edit%20Profile/profile_edit.dart';
import 'package:faap/Views/Dashboard/Profile/password_change_screen.dart';
import 'package:faap/Views/Dashboard/Profile/privacy_settings.dart';
import 'package:faap/Views/Dashboard/Profile/webview_screen.dart';
import 'package:faap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../UI Helper/Buttons/primary_button.dart';
import '../../../UI Helper/colors.dart';
import '../../../UI Helper/custom_appbar.dart';
import '../../../UI Helper/custom_listtile.dart';
import '../../../UI Helper/custom_message/custom_snackbar.dart';
import '../../Auth Screens/Provider/auth_provider.dart';
import 'about_us_screen.dart';
import 'app_settings_screen.dart';
import 'feedback_screen.dart';
import 'help_support_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade600,
                size: 28.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Delete Account',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _handleDeleteAccount(context, ref);
              },
              child: Text(
                'Yes, Delete',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDeleteAccount(
      BuildContext context, WidgetRef ref) async {
    final success = await ref.read(authProvider.notifier).deleteAccount();
    
    if (!context.mounted) return;

    if (success) {
      // Navigate to login screen and remove all previous routes
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const SignInScreenView(),
        ),
        (route) => false,
      );
      
      // Show success message
      CustomSnackbar.show(
        context: context,
        message: 'Your account has been deleted successfully',
        type: SnackbarType.success,
      );
    } else {
      final error = ref.read(authProvider).error;
      CustomSnackbar.show(
        context: context,
        message: error ?? 'Failed to delete account. Please try again.',
        type: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: 'Settings',
        transparent: true,
        leading: SizedBox.shrink(),
      ),
      body: ListView(
        children: [
          // Account section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACCOUNT',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomListTile(
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Manage your profile information',
                  onTap: () {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => const ProfileEditScreen(),
                      ),
                    );
                  },
                ),
                CustomListTile(
                  icon: Icons.key,
                  title: 'Password',
                  subtitle: 'Change your password',
                  onTap: () {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => const PasswordChangeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border),
          // Preferences section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PREFERENCES',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomListTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Manage your notification settings',
                  onTap: () {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
                CustomListTile(
                  icon: Icons.shield,
                  title: 'Privacy',
                  subtitle: 'Manage your privacy settings',
                  onTap: () {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => const PrivacySettingsScreen(),
                      ),
                    );
                  },
                ),
                InkWell(onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewScreen(
                        title: 'Sources & References',
                        url: 'https://faapscan.chassinc.org/sources_refrence.html',
                      ),
                    ),
                  );
                },child: CustomListTile(icon: Icons.notes, title: "Sources & References", subtitle: "Check the Sources & References")),
                CustomListTile(
                  icon: Icons.settings,
                  title: 'App Settings',
                  subtitle: 'Manage general app settings',
                  onTap: () {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => const AppSettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border),
          // Support section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUPPORT',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomListTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => const HelpSupportScreen(),
                      ),
                    );
                  },
                ),
                CustomListTile(
                  icon: Icons.email,
                  title: 'Feedback',
                  subtitle: 'Send us for improvements',
                  onTap: () {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                    );
                  },
                ),
                CustomListTile(
                  icon: Icons.info,
                  title: 'About',
                  subtitle: 'About our Mission',
                  onTap: () {
                    navigatorKey.currentState?.push(
                      MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border),
          // Legal section
          // Padding(
          //   padding: EdgeInsets.all(16.w),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'LEGAL',
          //         style: GoogleFonts.inter(
          //           fontSize: 12.sp,
          //           fontWeight: FontWeight.w600,
          //           color: AppColors.primary,
          //           letterSpacing: 1.2,
          //         ),
          //       ),
          //       SizedBox(height: 8.h),
          //       CustomListTile(
          //         icon: Icons.description,
          //         title: 'Terms of Service',
          //         subtitle: 'View our terms of service',
          //         onTap:
          //             () => ScaffoldMessenger.of(context).showSnackBar(
          //               const SnackBar(
          //                 content: Text('Terms of Service tapped'),
          //               ),
          //             ),
          //       ),
          //       CustomListTile(
          //         icon: Icons.description,
          //         title: 'Privacy Policy',
          //         subtitle: 'View our privacy policy',
          //         onTap:
          //             () => ScaffoldMessenger.of(context).showSnackBar(
          //               const SnackBar(content: Text('Privacy Policy tapped')),
          //             ),
          //       ),
          //     ],
          //   ),
          // ),
          // Divider(height: 1, color: AppColors.border),
          // Buttons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                PrimaryButton(
                  text: 'Logout',
                  icon: Icons.logout,
                  isLoading: authState.isLoading,
                  onPressed:
                      authState.isLoading
                          ? null
                          : () async {
                            final success =
                                await ref.read(authProvider.notifier).signOut();
                            if (success && context.mounted) {
                              // Navigate to login screen and remove all previous routes
                              navigatorKey.currentState?.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const SignInScreenView(),
                                ),
                                (route) => false,
                              );
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Failed to logout. Please try again.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                ),
                SizedBox(height: 8.h),
                PrimaryButton(
                  text: 'Delete Account',
                  icon: Icons.delete,
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red.shade600,
                  isLoading: authState.isLoading,
                  onPressed: authState.isLoading
                      ? null
                      : () => _showDeleteAccountDialog(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
