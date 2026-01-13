import 'package:faap/UI Helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const RoundedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.isOutlined = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? AppColors.border),
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: foregroundColor ?? AppColors.textSecondary,
          minimumSize: Size(width ?? double.infinity, height ?? 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.epilogue(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(width ?? double.infinity, height ?? 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.epilogue(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
