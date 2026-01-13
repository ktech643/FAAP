import 'package:faap/Services/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../UI Helper/Buttons/rounded_button.dart';
import '../../UI Helper/colors.dart';
import '../../main.dart';
import '../Dashboard/dashboard_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Future<void> _handleEnableNotifications(BuildContext context) async {
    // Request notification permission
    final granted = await PermissionService.requestNotificationPermission();
    
    if (granted) {
      print('✅ Notification permission granted');
    } else {
      print('❌ Notification permission denied');
    }
    
    // Navigate to dashboard regardless of permission result
    if (context.mounted) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }

  Future<void> _handleNotNow(BuildContext context) async {
    print('⏭️ User skipped notification permission');
    
    // Navigate to dashboard
    if (context.mounted) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => _handleNotNow(context),
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 160.h,
              width: 160.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_active,
                size: 80.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Stay in the loop',
              style: GoogleFonts.epilogue(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Enable notifications to get real-time alerts on harmful additives, health insights, and personalized recommendations.',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  RoundedButton(
                    text: 'Enable Notifications',
                    onPressed: () => _handleEnableNotifications(context),
                  ),
                  SizedBox(height: 12.h),
                  RoundedButton(
                    text: 'Not Now',
                    isOutlined: true,
                    onPressed: () => _handleNotNow(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
