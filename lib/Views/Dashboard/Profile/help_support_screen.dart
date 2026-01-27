import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:faap/Views/Dashboard/Profile/webview_screen.dart';
import 'package:faap/Services/email_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: 'Help & Support', transparent: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              margin: EdgeInsets.only(bottom: 24.h),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search FAQs',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.secondary,
                    fontSize: 16.sp,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.secondary),
                  // filled: true,
                  // fillColor: AppColors.greyVeryLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
            // Frequently Asked Questions
            Text(
              'Frequently Asked Questions',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Column(
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'How do I scan a product?',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  iconColor: AppColors.secondary,
                  collapsedIconColor: AppColors.secondary,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'For the best and most accurate results, scan the ‘ingredients label’ on the product. To scan, tap the ‘Scan’ icon in the bottom navigation bar. Point your phone’s camera at the product’s ingredients label (where ingredients are listed in text). Hold your phone’s steady and ensure the text is clearly visible. The app will instantly analyze additives and preservatives used in the product and identify harmful ingredients that are associated with health concerns.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'What do the different color codes mean?',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  iconColor: AppColors.secondary,
                  collapsedIconColor: AppColors.secondary,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'The color codes indicate the potential health impact of an additive. Green is generally safe, yellow suggests caution, and red indicates a potentially harmful additive.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'How can I report an issue?',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  iconColor: AppColors.secondary,
                  collapsedIconColor: AppColors.secondary,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'You can report an issue through the \'Contact Us\' section on this screen. Choose your preferred method to get in touch with our support team.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32.h),
            // Contact Us
            Text(
              'Contact Us',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Column(
              children: [
                _buildContactItem(
                  context,
                  icon: Icons.email,
                  title: 'Email Support',
                  subtitle: 'faapscan@chassinc.org',
                  onTap:
                      () => EmailService.launchEmail(
                        context,
                        email: 'faapscan@chassinc.org',
                        subject: 'FAAP Support Request',
                      ),
                ),
                SizedBox(height: 12.h),
                _buildContactItem(
                  context,
                  icon: Icons.forum,
                  title: 'In-App Messaging',
                  subtitle: 'Chat with us directly',
                  onTap:
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('In-App Messaging tapped'),
                        ),
                      ),
                ),
                SizedBox(height: 12.h),
                _buildContactItem(
                  context,
                  icon: Icons.language,
                  title: 'Visit Our Website',
                  subtitle: 'www.faapscan.chassinc.org',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const WebViewScreen(
                              title: 'FAAP Scan',
                              url: 'https://faapscan.chassinc.org/',
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: AppColors.white.withOpacity(0.8),
      //   selectedItemColor: AppColors.primary,
      //   unselectedItemColor: AppColors.secondary,
      //   currentIndex: 4, // Profile
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.qr_code_scanner),
      //       label: 'Scan',
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
      //     BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Health'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Profile',
      //     ),
      //   ],
      //   onTap: (index) {
      //     // Handle navigation if needed
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(
      //           'Navigated to ${['Home', 'Scan', 'History', 'Health', 'Profile'][index]}',
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.greyVeryLight,
              child: Icon(icon, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.secondary, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
