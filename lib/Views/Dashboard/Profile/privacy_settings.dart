import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_appbar.dart';
import 'package:faap/Views/Dashboard/Profile/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool shareData = true;
  bool personalizedContent = true;
  bool anonymousData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Privacy Settings'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data Management Section
              // Text(
              //   'Data Management',
              //   style: GoogleFonts.inter(
              //     fontSize: 18.sp,
              //     fontWeight: FontWeight.w600,
              //     color: AppColors.textPrimary,
              //   ),
              // ),
              // SizedBox(height: 8.h),
              // Container(
              //   decoration: BoxDecoration(
              //     color: AppColors.white,
              //     borderRadius: BorderRadius.circular(12.r),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.05),
              //         blurRadius: 4,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     children: [
              //       _buildSwitchTile(
              //         title: 'Share Data with Partners',
              //         subtitle:
              //             'Help improve our services by sharing anonymized data.',
              //         value: shareData,
              //         onChanged: (value) => setState(() => shareData = value),
              //       ),
              //       Divider(height: 1, color: AppColors.border),
              //       _buildSwitchTile(
              //         title: 'Personalized Content',
              //         subtitle: 'Get recommendations based on your activity.',
              //         value: personalizedContent,
              //         onChanged:
              //             (value) =>
              //                 setState(() => personalizedContent = value),
              //       ),
              //       Divider(height: 1, color: AppColors.border),
              //       _buildSwitchTile(
              //         title: 'Anonymous Data Collection',
              //         subtitle: 'Allow us to collect data to improve the app.',
              //         value: anonymousData,
              //         onChanged:
              //             (value) => setState(() => anonymousData = value),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 32.h),
              // Legal Section
              Text(
                'Legal',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
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
                child: Column(
                  children: [
                    _buildLinkTile(
                      title: 'Privacy Policy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WebViewScreen(
                              title: 'Privacy Policy',
                              url: 'http://faapscan.chassinc.org/privacy.html',
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(height: 1, color: AppColors.border),
                    _buildLinkTile(
                      title: 'Terms of Service',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WebViewScreen(
                              title: 'Terms & Conditions',
                              url: 'http://faapscan.chassinc.org/terms.html',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Container(
      //       padding: EdgeInsets.all(16.w),
      //       color: AppColors.white,
      //       child: PrimaryButton(
      //         text: 'Save Changes',
      //         onPressed:
      //             () => ScaffoldMessenger.of(context).showSnackBar(
      //               const SnackBar(content: Text('Changes saved')),
      //             ),
      //       ),
      //     ),
      //     BottomNavigationBar(
      //       backgroundColor: AppColors.white,
      //       selectedItemColor: AppColors.primary,
      //       unselectedItemColor: AppColors.secondary,
      //       selectedLabelStyle: GoogleFonts.inter(
      //         fontSize: 12.sp,
      //         fontWeight: FontWeight.w500,
      //       ),
      //       unselectedLabelStyle: GoogleFonts.inter(fontSize: 12.sp),
      //       type: BottomNavigationBarType.fixed,
      //       currentIndex: 4, // Profile is active
      //       items: const [
      //         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.qr_code_scanner),
      //           label: 'Scan',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.history),
      //           label: 'History',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.favorite),
      //           label: 'Health',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.person),
      //           label: 'Profile',
      //         ),
      //       ],
      //       onTap: (index) {
      //         // For now, do nothing or navigate if needed
      //         ScaffoldMessenger.of(
      //           context,
      //         ).showSnackBar(SnackBar(content: Text('Nav item $index tapped')));
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
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
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.secondary,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
