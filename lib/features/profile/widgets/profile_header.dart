import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final bool isPremium;
  
  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.isPremium,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xl),
        
        // Profile Picture
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'G',
              style: AppTypography.h2.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        )
            .animate()
            .scale(
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),
        
        const SizedBox(height: AppSpacing.lg),
        
        // User Name
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userName,
              style: AppTypography.h4.copyWith(
                color: AppColors.white,
              ),
            ),
            if (isPremium) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 12,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'PRO',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        )
            .animate()
            .fadeIn(delay: 300.ms),
        
        const SizedBox(height: AppSpacing.xs),
        
        // User Email
        Text(
          userEmail,
          style: AppTypography.body.copyWith(
            color: AppColors.white.withOpacity(0.8),
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms),
      ],
    );
  }
}