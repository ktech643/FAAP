import 'package:faap/UI Helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? trailingIconColor;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconBackgroundColor,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.trailingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor:
                  iconBackgroundColor ?? AppColors.primary.withOpacity(0.1),
              child: Icon(icon, color: iconColor ?? AppColors.primary),
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
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: subtitleColor ?? AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: trailingIconColor ?? AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
