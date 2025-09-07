import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_shadows.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool iconAtEnd;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final EdgeInsets? padding;
  
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.iconAtEnd = false,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = AppSpacing.buttonHeight,
    this.padding,
  });
  
  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = isOutlined
        ? Colors.transparent
        : (backgroundColor ?? AppColors.primaryGreen);
    
    final defaultTextColor = isOutlined
        ? (textColor ?? AppColors.primaryGreen)
        : (textColor ?? AppColors.white);
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: isOutlined || onPressed == null
            ? AppShadows.none
            : AppShadows.buttonShadow,
      ),
      child: Material(
        color: onPressed == null
            ? AppColors.gray300
            : defaultBackgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Container(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.buttonPaddingHorizontal,
                ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: isOutlined
                  ? Border.all(
                      color: onPressed == null
                          ? AppColors.gray300
                          : defaultTextColor,
                      width: 1.5,
                    )
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          defaultTextColor,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null && !iconAtEnd) ...[
                          Icon(
                            icon,
                            color: onPressed == null
                                ? AppColors.gray500
                                : defaultTextColor,
                            size: AppSpacing.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          text,
                          style: AppTypography.button.copyWith(
                            color: onPressed == null
                                ? AppColors.gray500
                                : defaultTextColor,
                          ),
                        ),
                        if (icon != null && iconAtEnd) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            icon,
                            color: onPressed == null
                                ? AppColors.gray500
                                : defaultTextColor,
                            size: AppSpacing.iconSm,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}