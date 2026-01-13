import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_imageloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanItemWidget extends StatelessWidget {
  final String name;
  final String date;
  final String grade;
  final Color gradeColor;
  final String imageUrl;
  final VoidCallback? onTap;

  const ScanItemWidget({
    super.key,
    required this.name,
    required this.date,
    required this.grade,
    required this.gradeColor,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.greyLight),
          boxShadow: [BoxShadow(color: AppColors.greyVeryLight, blurRadius: 4)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CustomImageLoader(
                imageUrl: imageUrl,
                width: 56.w,
                height: 56.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    date,
                    style: GoogleFonts.notoSans(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            //TODO UNCOMMENT GRADE/Status WHEN READY
            // Text(
            //   grade,
            //   style: GoogleFonts.inter(
            //     fontSize: 14.sp,
            //     fontWeight: FontWeight.bold,
            //     color: gradeColor,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
